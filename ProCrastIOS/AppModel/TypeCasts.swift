//
//  TypeCasts.swift
//  contributrack
//
//  Created by Ayush Raman on 9/2/21.
//

import Foundation
import Firebase
import SwiftUI

extension View {
    func bottomPad(_ val: CGFloat? = .none) -> some View {
        padding(.bottom, val)
    }
    func topPad(_ val: CGFloat? = .none) -> some View {
        padding(.top, val)
    }
}

extension Int {
    func toDouble() -> Double {
        Double(self)
    }
}

extension Double {
    func toInt() -> Int {
        Int(self)
    }
}

extension ArraySlice {
    func toArray() -> [Element] {
        Array(self)
    }
}

extension Dictionary.Keys {
    func toArray() -> [Element] {
        Array(self)
    }
}

extension Dictionary {
    func getKeys() -> [Key] {
        Array(self.keys)
    }
    func getValues() -> [Value] {
        Array(self.values)
    }
}
