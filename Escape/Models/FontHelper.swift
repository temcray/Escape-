//
//  FontHelper.swift
//  Escape
//
//  Created by Tatiana6mo on 7/18/26.
//

import SwiftUI

func appFont(_ style: Font.TextStyle) -> Font {
    let size: CGFloat
    let savedSize = UserDefaults.standard.string(forKey: "fontSize") ?? "Medium"
    
    switch savedSize {
    case "Small":
        size = style == .largeTitle ? 28 : style == .title ? 22 : style == .headline ? 14 : 12
    case "Large":
        size = style == .largeTitle ? 48 : style == .title ? 36 : style == .headline ? 22 : 18
    default:
        size = style == .largeTitle ? 38 : style == .title ? 28 : style == .headline ? 17 : 15
    }
    
    return .system(size: size)
}
