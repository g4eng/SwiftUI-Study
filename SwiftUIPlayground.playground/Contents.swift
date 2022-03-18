//: A UIKit based Playground for presenting user interface
  
import SwiftUI
import PlaygroundSupport

struct ContentView: View {
    var body: some View {
        Text("Hello SwiftUI")
        Text("Hello ").foregroundColor(.green).italic()
        + Text("SwiftUI").foregroundColor(.blue).bold()
        Text("Hello ✋\n SwiftUI 😀").font(.title) // 좌측 이미지
        Text("Hello ✋\n SwiftUI 😀").font(.title).lineLimit(1) // 우측 이미지
    }
}
// Present the view controller in the Live View window
// liveView 프로퍼티 값에 ContentView 인스턴스를 그냥 넣어주면 에러가 나니까
// UIHostingController의 rootView에 넣어주자
// PlaygroundPage.current.liveView = UIHostingController(rootView: ContentView())
// UIHostingController를 쓰지 않고도 SwiftUI의 뷰를 적용할 수 있는 한 가지 방법이 더 있다.
PlaygroundPage.current.setLiveView(ContentView())
