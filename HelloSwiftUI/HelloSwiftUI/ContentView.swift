//
//  ContentView.swift
//  HelloSwiftUI
//
//  Created by gaeng on 2022/03/16.
//

import SwiftUI

// VC와 같은 역할
struct ContentView: View {
    var body: some View {
        Text("Hello, SwiftUI!")
            .font(.largeTitle)
            .foregroundColor(.red).fontWeight(.bold)
            .colorInvert()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
