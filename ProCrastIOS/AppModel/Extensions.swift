//
//  Extensions.swift
//  ProCrastIOS
//
//  Created by Ayush Raman on 9/7/21.
//

import Foundation
import SwiftUI

extension Int{
    func double() -> Double{
        Double(self)
    }
}

extension Array where Element == Double {
    func mean() -> Double? {
        ProCrastIOS.mean(arr: self)
    }
    
    func median() -> Double? {
        return ProCrastIOS.median(arr: self)
    }
}

extension Color {
    static func randomColor() -> Color {
        let presets = [Color("darkGreen"), Color("pastelGreen"), Color("pastelRed"), Color("magenta"), Color("pink"), Color("pastelBlue"), Color("purple"), Color("pastelAqua")]
        return presets[Int.random(in: 0 ... presets.count - 1)]
    }
}
