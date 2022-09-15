# Opaque Type(SE-0244)

불투명 결과 타입(Opaque Result Type) 또는 불투명 반환 타입(Opaque Return Type)이라고도 하는, 한 번에 잘 와닿지 않는 이 이름은 조금 복잡한 개념이다

`var body: some View { ... }`

여기서 body의 타입에 붙은 some이 불투명 타입에 관련된 키워드로서, 프로퍼티나 첨자, 함수 등의 반환 타입에 한정적으로 사용된다

불투명 타입이 왜 생겼는지 살펴보자

## 타입 정보 은닉

body가 가진 반환 타입은 반드시 some View여야 하는 것은 아니다

다만, some은 그냥 빼 버리면 두 곳에서 오류가 발생하는 것을 보게 될 것이다

![error](https://github.com/gaeng2y/SwiftUI-Study/tree/main/contents/Opque%20Type-1)

하나는 연관 타입을 가진 프로토콜을 사용할 때 타입을 유추할 수 없어 발생하는 오류이고,

다른 하나는 이로 인해 뷰 프로토콜의 조건을 만족하지 않아서 발생하는 오류이다

```swift
protocol View {
	associatedtype Body: View
	var body: Self.Body { get }		// Body에 대한 타입 정보가 필요
}
```

따라서 반환 타입을 다음과 같이 수정하면 Body 연관 타입이 Text로 지환되면서 아무런 문제없이 동작한다

```swift
var body: Text {
	Text("Hello, SwiftUI")
```

그런데 여기에 두 개의 수식어를 추가해 보면 이런 식으로 body의 반환 타입이 조금 복잡해진다

```swift
var body: ModifiedContent<Text, _BackgroundModifier<Color>> {
	Text("Hello, SwiftUI")
		.foregroundColor(.white)
		.background(Color.black)
}
```

그나마 아직은 이해할 만하지만, 뷰와 수식어가 추가될수록 점점 감당할 수 없을 정도로 길어지게 될 것이다

UIKit에서는 뷰의 설정을 바꾸거나 자식 뷰를 추가한다고 그 자신의 타입이 바뀌는 것은 아니었지만, 

구조체를 사용하고 제네릭을 적극적으로 활용하는 SwiftUI의 구현 방식에서는 뷰를 추가허간 변경할 때마다 새로운 타입이 만들어지고 있는 것이다

그럼 이렇게 뷰가 추가되거나 빠질 때마다 body의 타입도 계속해서 수정해 주어야 한다면 어떨까?

또, 타입 정보에는 `_PaddingLayout`, `_PaddingLayout`처럼 우리가 사용할 수도 없고, 프레임워크 제공자가 공개하기 꺼려할 수도 있는 타입들도 포함되어 있다는 것도 감안해야 한다

바로 이것이 불투명 타입을 사용하게 된 이유이다

some View와 같은 불투명 타입은 앞에서 본 기다란 반환 타입처럼 특정 실체 타입(correct type)을 반환하는 대신, 타입 정보를 숨기고 프로토콜에 대한 정보만 남긴 채 API를 사용할 수 있도록 도와준다

이렇게 불투명 타입은 컴파일러만 정확한 타입 정보에 접근하고 모듈의 클라이언트는 불투명한 타입을 이용하도록 강제하는 역할을 할 수 있다

이것은 특히 프레임워크나 라이브러리 제공자 측에서 구현에 사용하는 구체적인 타입들을 명시하는 댇신, API를 추상화하고 모듈 간 결합성을 낮추는데 도움이 된다

예를 들어, 모듈 제공자가 반환 타입을 Text라고 지정해 버린 함수는 항상 Text라고 반환해야 하지만,

some View와 같은 불투명 타입으로 지정해 두었다면 차후에 클라이언트에 영향을 받지 않고 내부 구현을 쉽게 바꿀 수 있다

```swift
func someValue() -> Text {  }

// 원래 구현 내용이었던 텍스트를 제거하고, 그 대신 이미지로 대체
// 뷰 프로토콜만 준수한다면 어떤 타입이든 무관
func someValue() -> some View {
	// Text("Hello")
	Image("Hello")
}
```

불투명 타입은 제네릭을 반대로 적용하는 것 같은 개념이기에, 리버스 제네릭이라고도 한다

따라서 제네릭과 함께 살펴보면 좀 더 쉽게 불투명 타입을 이해할 수 있다

## 타입 추상화

제네릭은 코드를 호출하는 측(caller)에서 호출되는 측(callee)의 타입을 결정한다

```swift
// 함수는 추상화된 Animal 프로토콜 타입에 대해 구현
func genericFunction<T: Animal>(_ animal: T) { ... }
genericFunction(Dog())	// T == Dog, 함수를 호출하는 코드가 타입 결정
genericFunction(Cat())	// T == Cat
```

하지만 불투명 타입은 반대로 호출된 코드가 호출한 코드의 타입을 결정한다

```swift
// 호출된 쪽에서 타입을 결정
func opaqueTypeFunction() -> some Animal { Dog() }
// 호출한 측은 추상화된 타입을 전달 받음
let animal: some Animal = opaqueTypeAnimal()
```
## 정적 타입 시스템

제네릭의 매개 변수가 그렇듯 불투명 타입 역시 정적 타입 시스템에서만 불투명성이 유지되며, 런타임에서는 타입이 드러난다

따라서 실제 타입과 그것을 가린 불투명 타입은 컴파일 타임에는 같은 타입이 아니지만, 런타임 시에는 실제 타입을 다루는 것처럼 취급하고 사용할 수 있다

```swift
protocol Animal {}
strvut Dog: Animal { var color = "brown" }
let dog: some Animal = Dog()
dog.color 	// 컴파일 오류
(dog as! Dog).color 	// "borwn"
```
## 타입 정체성

기존처럼 프로토콜을 반환 타입으로 사용할 때는 그 프로토콜을 준수하는 어떤 타입이든 반환할 수 있어 그 유연함이 장점이지만, 함수를 호출할 때마다 서로 다른 타입이 반환될 수 있다는 점 때문에 타입에 대한 정보를 잃는 단점이 있다

```swift
func protocoolReturnType() -> Animal {
	.random() ? Dog() : Cat()
]
let animal: Animal = protocolReturnType() // Dog? Cat?
```

이것은 다음과 같이 중첩된 형태로 사용할 수 없다는 문제도 야기한다

```swift
protocol P {}
strcut SomeType: P {}
func nested<T: P>(_ param: T) -> P {
	param
}
let foo: P = nested(SomeType())
let bar = nested(foo)	// 컴파일 오류. foo는 그 자신인 P 프로토콜을 준수하지 않음
```

이 코드에서 foo 변수는 실체 타입인 SomeType에 대한 정보를 잃어버리고 P 프로토콜에 대한 타입 정보만 가지고 있게 된다

따라서 P 프로토콜 타입은 그 자신의 프로토콜을 준수하지 않는 것으로 여겨져서 컴파일 오류가 발생한다

또, Self 타입 또는 연관 타입이 선언된 프로토콜은 그 타입에 대해 명시가 되었거나 추론할 수 있는 경우에만 사용할 수 있다

그래서 매개 변수나 반환 타입으로 쓸 수 없어 다음 코드들은 모두 오류가 발생한다

```swift
func someFunction(lhs: Equatable, rhs: Equatable) -> Bool { ... }
func someFunction() -> Hashable { ... }
var someProperty: Collection { ... }
```

앞에서 살펴본 것처럼 프로토콜 타입은 그 유연함이 장점이지만, 이를 위해 놓치게 되는 부분들이 존재한다

하지만 불투명 타입을 이용하면 타입 정체성을 보존할 수 있어 이런 부분을 보완할 수 있다

불투명 타입은 이를 위해 두 가지를 강제하는데 반환값은 반드시 실체 타입이어야 한다는 점과 값은 다를지언정 타입은 반드시 동일해야 한다는 것이다

### 실제 타입

따라서 다음 코드를 작성하면 컴파일 오류가 발생한다

```swift
func returnConcreteType() -> some Animal {
	let result: Animal = Dog()
	return reuslt // Compile Error
}
// Error desc
Protocol type 'Animal' cannot conform to 'Animal' because only concrete types can conform to protocols
```

실체 타입이 아닌 프로토콜 타입을 반환해 발생하는 오류로 반환 타입을 Animal 대신 Dog로 변경해 주면 문제가 해결된다

프로토콜 대신 실체 타입만 반환하게 하는 것은 다음에 설명할 언제나 동일한 타입을 반환해야 한다는 조건을 지키려는 것이기도 한다

### 동일 타입

Self 타입이나 연관 타입을 가진 프로토콜을 사용하려면 제네릭이 필요했다

다음 코드에서 두 가지를 눈여겨보자

함수의 제네릭 매개 변수 T는 함수를 호출하는 코드에서 타입에 대한 정보를 제공하며, lhs와 rhs라는 두 매개 변수는 값이 다르더라도 동일한 타입을 갖는다

```swift
func genericFunction<T: Equatable>(lhs: T, rhs: T) -> Bool {
	lhs == rhs // lhs와 rhs 타입은 항상 동일
}
genericFunction(lhs: "Swift", rhs: "UI")	// 호출하는 코드가 타입 정보 제공
```
불투명 타입은 여기서도 마찬가지로 제네릭과 동일한 개념을 반대 방향으로 적용한다고 생각하면 된다

Self 타입 또는 연관 타입은 함수에서 반환하는 값의 타입이 되며, 반환하는 값은 상황에 따라 달라지더라도 그 타입은 항상 동일해야 한다

```swift
func opaqueTypeFunction() -> some Equatable {
	// 반환하는 값이 타입 정보 제공, 항상 동일한 타입 반환
	.random() ? "Swift" : "UI"
}
```

그래서 상황에 따라 반환하는 값이 달라지면 컴파일 오류 발생

이로써 불투명 타입은 동일 함수에 대한 모든 호출이 같은 타입을 반환한다는 것을 보장하므로, 컴파일러가 반환 타입에 대한 정보를 보존하고 이용할 수 있게 한다

## 정리

* 불투명 타입은 자세한 타입과 구현에 대한 정보를 유저에 숨기고 특정 프로토콜 유형을 따르는 API라는 것만 전달하고 싶을 때 사용
* 프로토콜 타입을 반환하면서도 타입에 대한 정체성을 보장해, API 내부에서 강력한 타입 검사 기능을 활용할 수 있다
* some 키워드는 프로퍼티와 첨자, 함수에 반환 타입에만 적용 가능하고, some 다음에 올 수 있는 타입은 프로토콜, 클래스, Any, AnyObject로 한정된다







