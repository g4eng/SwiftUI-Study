# Function Builders

함수 빌더는 Swift에서 내장 도메인 특화 언어(DSL, Domain Specific Languages)를 정의하도록 추가된 문법이다

DSL은 SQL과 같이 독립적인 언어를 사용하는 방식의 외장 DSL과 호스트 언어에 내장되어 그 기능을 적극적으로 활용하는 내장 DSL로 구분하곤 하는데, 함수 빌더의 관심사는 내장 DSL에 관한 것이다

내장 DSL을 잘 설계하면 많은 상용구를 제거하고 간결한 코드를 가능하게 하고 특화된 기능을 쉽게 구현할 수 있도록 도와주기 때문이다

함수 빌더는 한번도 안써봤는데 어디서 사용하는거냐?

```swift
init (
	...,
	@ViewBuilder content: () -> Content
)
```

VStack의 생성자인데 스택을 만들 때 사용했던 문법이 바로 이 뷰 빌더가 제공하는 방식으로, SwiftUI 프레임워크에서 선언적 문법을 강화하는 데 사용되는 내장 Swift 도메인 특화 언어의 일종이다

그리고 이것이 함수 빌더라는 선언 속성에 의해 만들어진 커스텀 매개 변수 속성에 해당하는 것이기도 하다

이제 뷰 빌더의 정의를 살펴보면 앞에 @_functionBuilder라는 속성이 붙는 것을 볼 수 있다

## @ViewBuilder

뷰 빌더는 함수로 정의된 매개 변수에 뷰를 전달받아 하나 이상의 자식 뷰를 만들어 내는 기능을 수행한다

그래서 VStack을 만들 때 뷰 빌더 속성을 적용한 content에 단지 뷰를 나열하는 것만으로도, 쉽게 여러 개의 자식 뷰를 가진 컨테이너 뷰가 만들어졌다

우리가 직접 이 뷰 빌더를 활용하여 원하는 형태의 커스텀 뷰를 만들 수 있다

예를 들어, VStack의 특징을 가지지만, 뷰의 정렬 위치를 leading으로 지정하고 뷰의 간격도 조금 더 조밀하도록 spacing의 기본값을 4로 설정한 MyVStack이라는 뷰를 만들어야 한다고 가정하자

그럼 MyStack의 생성자에서 content 매개 변수에 @ViewBuilder 속성을 적용하고, body에서는 원하는 기본값을 가진 VStack을 만든 뒤 content를 전달해 주기만 하면 도니다

```swift
struct MyVStack<Content: View>: View {
	let content: Content
	init(@ViewBuilder content: () -> Content) {	 // 뷰 빌더 속성 적용
		self.content = content()
	}
	var body: some View {
		VStack(alignment: .leading, spacing: 5) { // VStack 생성자 기본값 설정
			content
		}
	}
}
```

### 뷰 최대 개수 유의 사항

뷰 빌더는 buildBLock이라는 타입 메소드에 값을 전달하고, 2개 이상의 뷰일 때는 TupleView라는 타입을 반환한다

`static func buildBlock<C0, C1>(C0, C1) -> TupleView<(C0, C1)>`

이때 buildBlock 매개 변수의 최대 개수는 10개이므로 ViewBuilder 속성 매개 변수에 전달할 수 있는 최대 개수 10개이다

그럼 더 많은 뷰를 추가하고 싶을 때는 뷰를 각각 개별적으로 추가하는 대신 컨테이너 뷰를 이용해야 한다

컨테이너 뷰에 다시 컨테이너 뷰를 넣는 방법을 사용하면 원하는 만큼 계속해서 추가할 수도 있다

```swift
VStack {
	VStack {
		...
	}
	VStack {
		...
	}
}
```

### 뷰 빌더 자동 합성 코드

여기서 VStack 내부로 전달된 뷰들은 그 내요에 따라 내부적으로 다음과 같은 형태로 변환된다

```swift
VStack {
	Text("Function Builder")
	Bool.random() ? Space() : Divider()
	if Bool.random() {
		Text("Optional")
	}
}
// 이 코드는 뷰 빌더를 통해 다음과 같은 형태로 구성
VStack {
	ViewBuilder.buildBlock(		// 3개의 매개 변수를 받는 buildBlock
		Text("Function Builder")
		// buildEither를 통한 선택적 사용
		Bool.random() ? ViewBuilder.buildEither(first: Space())
					  : ViewBuilder.buildEither(second: Divider()),
		// buildIf 조건문
		ViewBuilder.buildIf(Bool.random() ? Text("Optional"): nil)
	)
}
```

## 커스텀 함수 빌더

숫자를 입력하면 짝수만 반환하는 함수 빌더를 만들어 보겠다

우선, 함수 빌더에 사용될 이름을 가진 타입을 선언하고 @_functionBuilder라는 선언 속성을 추가해 준다

그리고 함수 빌더에서 일반적으로 사용되는 buildBlock 함수를 두 가지 경우로 나누어 각각 정의해 준다

```swift
@_functionBuilder		// 함수 빌더로 선언해 주는 속성 추가
struct EvenNumbers {	// @ViewBuilder처럼 적용될 이름, 이 경우 @EvenNumbers
	static func buildBlock(_ numbers: Int...) -> [Int] {          // Int...
		numbers.filter { $0.isMultiple(of: 2) }
	}
	static func buildBlock(_ numbers: [Int]) -> [Int] {         // [Int]
	}
}
```

이제 EvenNumbers라는 함수 빌더가 완성되었다

함수 빌더를 사용하는 방법은 다음과 같은 것들이 있다

### 연산 프로퍼티

연산 프로퍼티에 함수 빌더를 적용할 때는 연산 프로퍼티의 getter가 buildBlock의 입력값이 되고 buildBlock의 반환값이 연산 프로퍼티의 최종 결과값이 된다

```swift
@EvenNumbers var computedProperty: [Int] {
	1
	2
}
```

앞의 코드는 Int형 가변 인자 타입에 대한 buildBlock이 호출되는 데 반해 다음과 같이 배열로 입력했다면 Int 배열 타입을 매개변수로 가진 buildBlock이 호출된다

```swift
@EvenNumbers var computedProperty: [Int] {
	[1, 2, 3, 4]
}
// 결과: [2, 4]
```

이처럼 buildBlock은 상황에 맞는 함수가 호출되는데, 만약 입력한 값의 개수나 타입 등 적절한 함수가 선언되어 있지 않았다면 컴파일 오류가 발생한다

### 함수

함수 빌더를 함수 자체에 추가해 주는 방법도 있다

이 경우는 함수를 호출할 때 전달한 인수가 함수에서 먼저 처리된 뒤, 그 결과가 buildBlock의 입력값으로 전달된다

그리고 buildBlock의 결과가 최종 반환값이 된다

```swift
@EvenNumbers
func annotatedFunction(_ numbers: [Int]) -> [Int] {
	numbers.filter { $0 > 2 }			// 입력값을 전처리한 후 buildBlock으로 전달
}

annotatedFunction([1, 2, 3, 4])  // 함수 호출 시 입력하는 인수가 기본 입력값
```

### 함수의 매개 변수

매개 변수에 함수 빌더를 추가해 주는 것도 가능하다

이 때는 함수로 전달하는 값이 buildBlock의 입력값이 되고, buildBlock 함수가 호출되는 타이밍은 넘겨받은 함수를 실행했을 때가 된다

```swift
func annotatedParameter(@EvenNumbers _ content: () -> [Int]) -> [Int] {
	content()		// 함수를 실행했을 때 buildBlock 함수 호출
}
annotatedParameter { 1; 2; 3; 4; }	// 한 줄에 여러 값 입력 시 세미콜론 사용
```

그리고 이 방식을 생서자의 매개 변수에 추가해 주면, 뷰 빌더처럼 인스턴스를 생성할 때 즉시 함수 빌더 기능을 적용해 줄 수 있다

```swift
strut MyNumbers<T> {
	let numbers: T
	@inlinable init(@EvenNumbers content: () -> T) {
		self.numbers = content()
	}
}
let exmaple = MyNumbers {
	1
	2
}
example.numbers
```

# 정리

* 함수 빌더는 내장 DSL을 정의하고자 구현되었다
* 뷰 빌더는 함수 빌더를 이용해 만들어진 SwiftUI 프레임워크를 위한 내장 Swift DSL이며, 뷰 생성 시 전달받은 함수를 통해 하나 이상의 자식 뷰를 만드는 데 사용된다
* 연산 프로퍼티, 함수, 함수의 매개 변수에 커스텀 함수 빌더를 적용할 수 있다