//
//  Order.swift
//  FruitMart
//
//  Created by gaeng on 2022/10/19.
//

import Foundation

struct Order: Identifiable {
    static var orderSequence = sequence(first: 1) { $0 + 1 }
    
    let id: Int
    let product: Product
    let quantity: Int
    
    var price: Int {
        product.price * quantity
    }
}
