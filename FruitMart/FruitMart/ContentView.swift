//
//  ContentView.swift
//  FruitMart
//
//  Created by gaeng on 2022/09/14.
//

import SwiftUI

class User: ObservableObject {
    let name = "User name"
    @Published var score = 0
}

struct ContentView: View {
    @ObservedObject var user: User
    
    var body: some View {
        VStack(spacing: 30) {
//            Toggle(isOn: $isFavorite) {
//                Text("isFavorite: \(isFavorite.description)")
//            }
//
//            Stepper("Count: \(count)", value: $count)
            Text(user.name)
            
            Button {
                self.user.score += 1
            } label: {
                Text(user.score.description)
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(user: User())
    }
}
