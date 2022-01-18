//
//  ContentView.swift
//  Landmarks
//
//  Created by gaeng on 2022/01/18.
//

import SwiftUI

// By default, SwiftUI view files declare two structures. The first structure conforms to the View protocol and describes the view’s content and layout. The second structure declares a preview for that view.
struct ContentView: View {
    var body: some View {
        // To customize a SwiftUI view, you call methods called modifiers. Modifiers wrap a view to change its display or other properties. Each modifier returns a new view, so it’s common to chain multiple modifiers, stacked vertically.
        Text("Turtle Rock")
            .font(.title)
            .foregroundColor(.green)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
