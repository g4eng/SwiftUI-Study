//
//  FavoriteButton.swift
//  FruitMart
//
//  Created by gaeng on 2022/10/19.
//

import SwiftUI

struct FavoriteButton: View {
    @EnvironmentObject private var store: Store
    let product: Product
    
    private var imageName: String {
        product.isFavorite ? "heart.fill" : "heart"
    }
    
    var body: some View {
        Button {
            self.store.toggleFavorite(of: self.product)
        } label: {
            Image(systemName: imageName)
                .imageScale(.large)
                .foregroundColor(.peach)
                .frame(width: 32, height: 32)
                .onTapGesture {
                    self.store.toggleFavorite(of: self.product)
                }
        }
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteButton(product: productSamples[0])
    }
}
