//
//  ProductDetailView.swift
//  FruitMart
//
//  Created by gaeng on 2022/09/17.
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @State private var quantity: Int = 1
    @State private var showingAlert: Bool = false
    @EnvironmentObject private var store: Store
    
    var body: some View {
        VStack(spacing: 0) {
            productImage // 상품 이미지
            orderView // 상품 정보 출력
        }
        .edgesIgnoringSafeArea(.top)
        // 기본적으로 뷰는 안전 영역을 기준으로 레이아웃 구성하지만, 이 수식어에 all, top, leading, bottom, trailing, vertical, horizontal 같은 Edge.Set 타입을 전달하여 지정한 방향의 안전 영역을 무시할 수 있다
        .alert(isPresented: $showingAlert) {
            confirmAlert
        }
    }
    
    var productImage: some View {
        GeometryReader { _ in
            Image(self.product.imageName)
                .resizable()
                .scaledToFill()
        }
    }
    
    var orderView: some View {
        GeometryReader {
            VStack(alignment: .leading) {
                self.productDescription // 상품명과 즐겨찾기 버튼(하트 모양) 이미지
                Spacer()
                self.priceInfo
                self.placeOrderButton
            } // 지오메트리 리더가 차지하는 뷰의 높이보다 VStack의 높이가 10 크도록 지정
            .frame(height: $0.size.height + 10)
            .padding(32)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -5)
        }
    }
    
    var productDescription: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(product.name)
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                
                Spacer()
                
                FavoriteButton(product: product)
            }
            
            Text(splitText(product.description))
                .foregroundColor(.sceondaryText)
                .fixedSize()
        }
    }
    
    var priceInfo: some View {
        let price = quantity * product.price
        return HStack {
            (Text("₩") // 통화 기호는 작게 나타내고 가격만 크게 표시
             + Text("\(price)")
                .font(.title)
            )
            .fontWeight(.medium)
            Spacer()
            // 수량 선택 버튼이 들어갈 위치 - 챕터 5에서 구현 예쩡
            QuantitySelector(quantity: $quantity)
        }
        .foregroundColor(.black)
    }
    
    var placeOrderButton: some View {
        Button {
            self.showingAlert = true
        } label: {
            Capsule()
                .fill(Color.peach)
            // 너비는 주어진 공간을 최대로 사용하고 높이는 최소, 최대치 지정
                .frame(maxWidth: .infinity, minHeight: 30, maxHeight: 55)
                .overlay(Text("주문하기")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(Color.white)
                )
                .padding(.vertical, 20)
        }
    }
    
    func splitText(_ text: String) -> String {
        guard !text.isEmpty else { return text }
        let centerIdx = text.index(text.startIndex, offsetBy: text.count / 2)
        let centerSpaceIdx = text[..<centerIdx].lastIndex(of: " ")
        ?? text[centerIdx...].firstIndex(of: " ")
        ?? text.index(before: text.endIndex)
        let afterSpaceIdx = text.index(after: centerSpaceIdx)
        let lhsString = text[..<afterSpaceIdx].trimmingCharacters(in: .whitespaces)
        let rhsString = text[afterSpaceIdx...].trimmingCharacters(in: .whitespaces)
        return String(lhsString + "\n" + rhsString)
    }
    
    var confirmAlert: Alert {
        Alert(title: Text("주문 확인"),
              message: Text("\(product.name)을(를) \(quantity)개 구매하겠습니까?"),
              primaryButton: .default(Text("확인"), action: {
                // 주문 기능 구현 예정
                self.placeOrder()
              }),
              secondaryButton: .cancel(Text("취소")))
    }
    
    func placeOrder() {
        store.placeOrder(product: product, quantity: quantity)
    }
}

struct ProductDetailView_Previews: PreviewProvider {
  static var previews: some View {
      let source1 = ProductDetailView(product: productSamples[0])
      let source2 = ProductDetailView(product: productSamples[1])
      return Group {
          Preview(source: source1)
          Preview(source: source2, devices: [.iPhone14Pro], displayDarkMode: false)
      }
  }
}

