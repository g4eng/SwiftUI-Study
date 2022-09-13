//
//  Home.swift
//  FruitMart
//
//  Created by gaeng2y on 2020/03/02.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import SwiftUI

struct Home: View {
  var body: some View {
      /*
       구조
       HStack {
           // 상품 이미지
           VStack {
               // 상품명
               // 상품 설명
               HStack {
                   // 가격 정보와 버튼
                   EmptyView() // 1. 어떤 내용도 표현하지 않으며 공간도 차지하지 않는 뷰, 스택 내부에는 반드시 하나 이상의 뷰를 넣어야 하므로, 이후에 추가할 기능을 구현하기 전에 임시방편으로 넣어둠
               }
           }
       }
       .frame(height: 150)
       */
      VStack {
          ProductRow()
          ProductRow()
          ProductRow()
      }
  }
}

struct Home_Previews: PreviewProvider {
  static var previews: some View {
    Home()
  }
}

struct ProductRow: View {
    var body: some View {
        HStack {
            Image("apple")
                .resizable()
                .scaledToFill()
                .frame(width: 140)
                .clipped()
            
            VStack(alignment: .leading) {
                // 상품명 부분에 작성
                Text("백설공주 사과")
                    .font(.headline)
                    .fontWeight(.medium)
                    .padding(.bottom, 6)
                // 상품 설명 부분에 작성
                Text("달콤한 맛이 좋은 과일의 여왕 사과. 독은 없고 꿀만 가득해요!")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                HStack(spacing: 0) {
                    Text("₩").font(.footnote)
                    + Text("2100").font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: "heart")
                        .imageScale(.large)
                        .foregroundColor(Color("peach"))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "cart")
                        .imageScale(.large)
                        .foregroundColor(Color("peach"))
                        .frame(width: 32, height: 32)
                    
                }
            }
            .padding([.leading, .bottom], 12)
            .padding([.top, .trailing])
        }
        .frame(height: 150)
        .background(Color.primary.colorInvert())
        .cornerRadius(6)
        .shadow(color: Color.primary.opacity(0.33), radius: 1, x: 2, y: 2)
        .padding(.vertical, 8)
    }
}
