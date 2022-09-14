//
//  ColorExtension.swift
//  FruitMart
//
//  Created by gaeng on 2022/09/15.
//

import SwiftUI

extension Color {
    static let peach = Color("peach")    // 앱에서 사용할 메인색
    static let primaryShadow = Color.primary.opacity(0.2)   // 그림자에 사용할 색
    static let sceondaryText = Color(hex: "#6e6e6e")
    static let background = Color(UIColor.systemGray6)
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)  // 문자열 파서 역할을 하는 클래스
        _ = scanner.scanString("#")     // scanString은 iOS 13부터 지원."#" 문자 제거
        
        var rgb: UInt64 = 0
        // 문자열을 Int64 타입으로 변환해 rgb 변수에 저장. 변환할 수 없다면 0을 반환
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double((rgb >> 0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
