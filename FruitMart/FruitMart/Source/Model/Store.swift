//
//  Store.swift
//  FruitMart
//
//  Created by gaeng on 2022/09/17.
//

import Foundation

// Store는 앱 전반에 걸쳐 사용하게 될 모델이므로 어디서든 쉽게 접근하고 활용할 수 있도록 environmentObject 수식어로 추가해 줄 것인데, 이 수식어는 ObservableObject 타입만을 받기 때문이다
final class Store: ObservableObject {
    @Published var products: [Product]
    @Published var orders: [Order] = []
    
    init(filename: String = "ProductData.json") {
        self.products = Bundle.main.decode(filename: filename, as: [Product].self)
    }
    
    func placeOrder(product: Product, quantity: Int) {
        let nextID = Order.orderSequence.next()!
        let order = Order(id: nextID, product: product, quantity: quantity)
        orders.append(order)
    }
}

extension Store {
    func toggleFavorite(of product: Product) {
        guard let index = products.firstIndex(of: product) else { return }
        products[index].isFavorite.toggle()
    }
}
