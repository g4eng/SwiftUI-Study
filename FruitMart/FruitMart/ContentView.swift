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

struct CustomButtonStyle: ButtonStyle {
    var backgroundColor: Color = .blue
    var cornerRadius: CGFloat = 6
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(RoundedRectangle(cornerRadius: cornerRadius)
                .fill(backgroundColor))
            .scaleEffect(configuration.isPressed ? 0.7 : 1.0)
    }
}

struct CustomPrimitiveButtonStyle: PrimitiveButtonStyle {
    var minimumDuration = 0.5
    
    func makeBody(configuration: Configuration) -> some View {
        ButtonStyleBody(configuration: configuration,
                        minimumDuration: minimumDuration)
    }
    
    private struct ButtonStyleBody:View {
        let configuration: Configuration
        let minimumDuration: Double
        // 1. @GestureState는 @State처럼 상태를 저장하는 역할이지만, 제스처가 동작하는 순간에만 값이 변화했다가 제스처 인식이 종료되면 다시 초기값으로 돌아간다
        @GestureState private var isPressed = false
        
        var body: some View {
            // 2 LongPressGesture가 인식하는 데까지 필요한 최소한의 시간을 minimumDuration을 통해 설정하고 그 이상의 시간 동안 버튼을 눌러야만 버튼 액션을 수행하게 된다
            let longPress = LongPressGesture(minimumDuration: minimumDuration)
                .updating($isPressed) { value, state, _ in
                    // 3. value는 버튼을 누르는지 여부를 전달해주는데, 이 값을 state에 저장하면 이것이 1번 항목의 isPressed 프로퍼티에 저장된다
                    state = value
                }
                .onEnded { _ in
                    // 4. 지정한 시간 동안 버튼을 누르면 LongPressGesture의 onEnded 이벤트가 발생한다
                    // 이때 configuration의 trigger
                    self.configuration.trigger()
                }
            
            return configuration.label
                .foregroundColor(.white)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10)
                    .fill(Color.green))
                .scaleEffect(isPressed ? 0.6 : 1.0)
                .opacity(isPressed ? 0.6: 1.0)
                .gesture(longPress)
        }
    }
}
