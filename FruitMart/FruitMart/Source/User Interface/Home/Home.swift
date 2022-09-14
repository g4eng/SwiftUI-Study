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
