//
//  Activity.swift
//  ProCrast
//
//  Created by Ayush Raman on 10/23/20.
//  Copyright © 2020 Answer Key. All rights reserved.
//

import Foundation
import SwiftUI

struct Textbook: Equatable, Codable, Identifiable {
    static func == (lhs: Textbook, rhs: Textbook) -> Bool{
        lhs.id == rhs.id
    }
    var id: String
    var pages: ClosedRange<Int>?
}

struct Task : Codable {
    let activity: Activity
    var completed = false
    var reps = 1
}

struct Entry : Codable {
    var time: Double
    var reps: ClosedRange<Int>
    func getUnitTime() -> Double {
        let range = reps.upperBound - reps.lowerBound
        return time / range.toDouble()
    }
}

struct Activity: Identifiable, Codable {
    var id: String
    var name: String
    var textbook: Textbook? = .none
    var entries: [Entry]
    
    init(_ n: String){
        name = n
        entries = []
        id = UUID().uuidString
    }
    
    func avgTime() -> Double? {
        guard entries.count != 0 else {
            return .none
        }
        return entries
            .map { $0.getUnitTime() }
            .mean()
    }
    func medianTime() -> Double? {
        guard entries.count != 0 else {
            return .none
        }
        return entries
            .map { $0.getUnitTime() }
            .median()
    }
    func formattedTime() -> String? {
        guard let avgTime = avgTime() else {
            return .none
        }
        return "\(Int(avgTime)) mins"
    }
    func formattedRecent() -> String {
        return "\(Int(entries[entries.count - 1].getUnitTime())) mins"
    }
}


// class for app model
class Model: ObservableObject {
    @Published var activities: [Activity] // published stream of activity array
    @Published var tasks: [Task] // published stream of tasks
    init(){
        self.activities = []
        self.tasks = []
    }
    func totalTime() -> Double {
        tasks
            .map {
                ($0.activity.avgTime() ?? 0) * $0.reps.double()
            }
            .reduce(0.0, +)
    }
    func highestTime() -> Double? {
        activities
            .map { ($0.entries.map { $0.getUnitTime() }.max() ?? 0) }
            .max()
    }
}
