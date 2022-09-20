//
//  Home.swift
//  FruitMart
//
//  Created by gaeng2y on 2020/03/02.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import SwiftUI

struct Home: View {
    let store: Store
    
  var body: some View {
      NavigationView {
          VStack {
              ExtractedView()
              Text("2")
                  .fontWeight(.medium)
              Text("3")
                  .fontWeight(.medium)
          }
          
//          List(store.products) { product in
//              NavigationLink(destination: Text("상세 정보")) {
////                  ProductRow(product: product)
//
//
//              }
//          }
          .navigationTitle("과일마트")
      }
  }
}

struct Home_Previews: PreviewProvider {
  static var previews: some View {
      Home(store: Store())
          .preferredColorScheme(.light)
  }
}

struct ExtractedView: View {
    var body: some View {
        Text("1")
            .fontWeight(.medium)
    }
}
