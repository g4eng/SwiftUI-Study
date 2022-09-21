//
//  Preview.swift
//  FruitMart
//
//  Created by gaeng on 2022/09/20.
//

import SwiftUI

struct Preview<V: View>: View {
    enum Device: String, CaseIterable {
        case iPhone8 = "iPhone 8"
        case iPhone11 = "iPhone 11"
        case iPhone11Pro = "iPhone 11 Pro"
        case iPhone11ProMax = "iPhone 11 Pro Max"
    }
    
    let source: V   // 프리뷰에서 표현될 뷰
    var devices: [Device] = [.iPhone11Pro, .iPhone11ProMax, .iPhone8]       // 1. 프리뷰에 렌더링할 기기에 대한 기본값 정의
    var displayDarkMode: Bool = true
    
    var body: some View {
        Group {
            ForEach(devices, id: \.self) {
                self.previewSource(device: $0)
            }
            if !devices.isEmpty && displayDarkMode {
                self.previewSource(device: devices[0])
                    .preferredColorScheme(.dark)            // 2. ForEach 외에 별도의 뷰를 하나 더 생성한 것은 다크 모드 환경에서의 결과 화면을 확인하고자 함
            }
        }
    }
    
    private func previewSource(device: Device) -> some View {
        source
            .previewDevice(PreviewDevice(rawValue: device.rawValue))
            .previewDisplayName(device.rawValue)
    }
}

struct Preview_Previews: PreviewProvider {
    static var previews: some View {
        // 3. 이제 Preview의 source 매개 변수에 간접적으로 뷰를 전달하는 형태로 사용하면, 매번 프리뷰를 볼 때마다 ForEach와 previewDevice 수식어를 사용해 기기를 지정해 줄 필요 없이 쉽게 미리 정의해 둔 목록에 따라 결과 화면을 비교해 볼 수 있다
        Preview(source: Text("Hello, SwiftUI!"))
    }
}
