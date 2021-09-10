//
//  Statistics.swift
//  contributrack
//
//  Created by Ayush Raman on 9/2/21.
//

import Foundation

func median(arr: [Double]) -> Double? {
    let sorted = arr.sorted()
    guard !sorted.isEmpty else {
        return .none
    }
    if sorted.count % 2 == 0 {
        return (sorted[(sorted.count / 2)] + sorted[(sorted.count / 2) - 1]) / 2
    } else {
        return sorted[(sorted.count - 1) / 2]
    }
}

func max(arr: [Double]) -> Double? {
    arr.max()
}

func min(arr: [Double]) -> Double? {
    arr.min()
}

func mean(arr: [Double]) -> Double? {
    guard !arr.isEmpty else {
        return .none
    }
    return arr.reduce(0.0, +) / arr.count.toDouble()
}
// 0, 1, 2, 3
func Q1(arr: [Double]) -> Double? {
    guard arr.count >= 4 else {
        return .none
    }
    return median(arr: (arr.count % 2 == 0 ? arr[0..<arr.count / 2] : arr[0...arr.count / 2]).toArray())
}

func Q3(arr: [Double]) -> Double? {
    guard arr.count >= 4 else {
        return .none
    }
    return median(arr: (arr.count % 2 == 0 ? arr[arr.count / 2 + 1...arr.count] : arr[arr.count / 2...arr.count]).toArray())
}

func IQR(arr: [Double]) -> Double? {
    guard let q1 = Q1(arr: arr) else {
        return .none
    }
    guard let q3 = Q3(arr: arr) else {
        return .none
    }
    return q3 - q1
}
