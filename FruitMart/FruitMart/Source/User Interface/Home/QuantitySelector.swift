//
//  QuantitySelector.swift
//  FruitMart
//
//  Created by gaeng on 2022/10/17.
//

import SwiftUI

struct QuantitySelector: View {
    @Binding var quantity: Int
    var range: ClosedRange<Int> = 1...20
    
    private let softFeedback = UIImpactFeedbackGenerator(style: .soft)
    private let rigidFeedback = UIImpactFeedbackGenerator(style: .rigid)
    
    var body: some View {
        HStack {
            Button {
                self.changeQuantity(-1)
            } label: {
                Image(systemName: "minus.circle.fill")
                    .imageScale(.large)
                    .padding()
            }
            .foregroundColor(.gray.opacity(0.5))
            
            Text("\(quantity)")
                .bold()
                .font(.system(.title, design: .monospaced))
                .frame(minWidth: 40, maxWidth: 60)
            
            Button {
                self.changeQuantity(1)
            } label: {
                Image(systemName: "plus.circle.fill")
                    .imageScale(.large)
                    .padding()
            }
            .foregroundColor(.gray.opacity(0.5))
        }
    }
    
    private func changeQuantity(_ num: Int) {
        if range ~= quantity + num {
            quantity += num
            softFeedback.prepare()
            softFeedback.impactOccurred(intensity: 0.8)
        } else {
            rigidFeedback.prepare()
            rigidFeedback.impactOccurred()
        }
    }
}

struct QuantitySelector_Previews: PreviewProvider {
    @State private var quantity = 0
    
    static var previews: some View {
        Group {
            QuantitySelector(quantity: .constant(1))
            QuantitySelector(quantity: .constant(10))
            QuantitySelector(quantity: .constant(20))
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
