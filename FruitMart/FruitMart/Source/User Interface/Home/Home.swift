//
//  Home.swift
//  FruitMart
//
//  Created by gaeng2y on 2020/03/02.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject private var store: Store
    
  var body: some View {
      NavigationView {
          List(store.products) { product in
              NavigationLink(destination: Text("상세 정보")) {
                  ProductRow(product: product)
              }
              .buttonStyle(PlainButtonStyle())
          }
          .navigationTitle("과일마트")
      }
  }
}

struct Home_Previews: PreviewProvider {
  static var previews: some View {
      Preview(source: Home())
          .environmentObject(Store())
  }
}
