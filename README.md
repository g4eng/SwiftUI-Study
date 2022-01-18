# SwiftUI 소개
* Swift를 기반으로 처음부터 새롭게 구성한 프레임워크
* AppKit, UIKit처럼 구분하지 않고 UI 영역까지 모든 플랫폼 개발 가능

## 특성

##### 더 우수한 앱, 더 적은 코드
* UIKit에 비해 코드의 길이가 굉장히 줄어드는 것을 경험할 수 있다.
* 적응형 레이아웃, 뷰 갱신, 현지화, 접근성, 유동적 글자 크기 등 우리가 직접 구현해야 했던 상당 부분을 프레임워크가 대신 지원해 주기 때문이다.

##### 선언형
```swift
struct ContentView: View {
	var body: some View 
		VStack {
			Text("SwiftUI")
				.font(.title)
				.fontWeight(.heavy)
				.foregroundColor(.primary)
				
			Image("logo")
				.resizable()
				.scaledToFit()
		}
		.padding()
	}
}
```
* SwiftUI는 기존의 명령형 대신 선언형 프로그래밍 방식 활용.
* UI를 어떻게 구성할 것인지 단계별로 만들어 나가는 대신 최종적으로 어떤 모습이 되기를 원하는지 그 결과를 선언하는 형태.

##### 디자인 도구
* Xcode 11부터 SwiftUI를 이용하면 시뮬레이터를 실행시키지 않고도 캔버스 영역 안에서 프리뷰를 통해 작업 중인 코드의 결과물을 확인 가능하다.

##### 모든 애플 플랫폼 지원
* 기존에는 각 플랫폼이 밑바탕에서 Foundation 프레임워크와 그래픽 영역까지는 공유하여 사용하더라도, UI 영역은 각각 구분하여 개발했어야 했다.
* iOS를 개발하려면 UIKit, macOS는 AppKit, watchOS는 WatchKit를 필요로 하는 등 플랫폼별로 각기 다른 프레임워크를 사용해야만 했었다.
