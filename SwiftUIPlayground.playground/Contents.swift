//: A UIKit based Playground for presenting user interface
  
import SwiftUI
import PlaygroundSupport

struct ContentView: View {
    var body: some View {
//        Text("Hello SwiftUI")
//        Text("Hello ").foregroundColor(.green).italic()
//        + Text("SwiftUI").foregroundColor(.blue).bold()
//        Text("Hello ✋\n SwiftUI 😀").font(.title) // 좌측 이미지
//        Text("Hello ✋\n SwiftUI 😀").font(.title).lineLimit(1) // 우측 이미지
        
        VStack(spacing: 30) {               // 세로 방향으로 뷰를 배열하는 컨테이너 뷰
            Text("폰트와 굵기 설정")
                .font(.title)               // 폰트 설정
                .fontWeight(.black)         // 폰트 굵기
            
            Text("글자색은 foreground, 배경은 background")
                .foregroundColor(.white)    // 글자색
                .padding()                  // 텍스트 주변 여백 설정
                .background(Color.blue)     // 텍스트의 배경 설정(Color 명시)
            
            Text("커스텀 폰트, 볼드체, 이탤릭체, 밑줄, 취소선")
                .font(.custom("Menlo", size: 16))   // 커스텀 폰트 설정
                .bold()                             // 볼드체
                .italic()                           // 이탤릭체
                .underline()                        // 밑줄
                .strikethrough()                    // 취소선
            
            Text("라인 수 제한과 \n 텍스트 정렬 기능입니다. \n 이건 안 보입니다.")
                .lineLimit(2)                           // 텍스트를 최대 2줄까지만 표현
                .multilineTextAlignment(.trailing)      // 다중행 문자열의 정렬 방식 지정
                .fixedSize()                            // 주어진 공간의 크기가 작아도 텍스트를 생략하지 않고 표현되도록 설정
            
            // 2개 이상의 텍스트를 하나로 묶어서 동시에 적용할 수도 있다.
            (Text("자간과 기준선").kerning(8))        // 자간
            + Text(" 조정도 쉽게 가능합니다.").baselineOffset(8)  // 기준선
                .font(.system(size: 16))
        }
    }
}
// Present the view controller in the Live View window
// liveView 프로퍼티 값에 ContentView 인스턴스를 그냥 넣어주면 에러가 나니까
// UIHostingController의 rootView에 넣어주자
// PlaygroundPage.current.liveView = UIHostingController(rootView: ContentView())
// UIHostingController를 쓰지 않고도 SwiftUI의 뷰를 적용할 수 있는 한 가지 방법이 더 있다.
PlaygroundPage.current.setLiveView(ContentView())
