//
//  ContentView.swift
//  FruitMart
//
//  Created by gaeng on 2022/09/14.
//

import SwiftUI

struct ContentView: View {
    @State private var showingSheet = false
    
    var body: some View {
        Button {
            self.showingSheet.toggle()
        } label: {
            Text("Present")
                .font(.title)
                .foregroundColor(.blue)
        }
        .sheet(isPresented: $showingSheet) {
            print("Dismissed")
        } content: {
            PresentedView()
        }


    }
}

struct PresentedView: View {
    // 1. presentationMode는 해당 뷰가 띄워져있는 상태인지를 알려주는 isPresented 프로퍼티와 화면을 닫는 dismiss 메소드 이렇게 두 가지를 제공하는 환경 변수다
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button {
            // 2. isPresented의 값을 가져와 현재 뷰의 출력 상태를 확인한다
            if self.presentationMode.wrappedValue.isPresented {
                /*
                 3. Sheet 스타일을 사용하는 경우 버튼을 눌러서 dismiss 메소드 호출 뿐만 아니라, 화면 상단 부분을 잡아 내리는 방법으로도 닫을 수 있고
                화면이 닫히고 나면 onDismiss 매개 변수에 정의했던 클로저가 불리게 된다
                 */
                self.presentationMode.wrappedValue.dismiss()
            }
        } label: {
            Text("Tap to Dismiss")
                .font(.title)
                .foregroundColor(.red)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
