//
//  Activity.swift
//  ProCrast
//
//  Created by Ayush Raman on 10/23/20.
//  Copyright © 2020 Answer Key. All rights reserved.
//

import Foundation
import SwiftUI
extension Color{
    static func randomColor() -> Color{
        let presets = [Color("darkGreen"), Color("pastelGreen"), Color("pastelRed"), Color("magenta"), Color("pink"), Color("pastelBlue"), Color("purple"), Color("pastelAqua")]
        return presets[Int.random(in: 0 ... presets.count - 1)]
    }
}
extension Array where Element == Double{
    func mean() -> Double{
        (self.reduce(0.0) { $0 + $1 })/(self.count.double() == 0 ? 1 : self.count.double())
    }
    func MAD() -> Double{
        self.map{ abs($0 - self.mean()) }.mean()
    }
    func median() -> Double {
        self.sorted()[self.count/2]
    }
}
struct Textbook: Equatable, Codable{
    static func == (lhs: Textbook, rhs: Textbook) -> Bool{
        lhs.ISBN == rhs.ISBN
    }
    var ISBN: String
    var pages: ClosedRange<Int>?
}
extension Int{
    func double() -> Double{
        Double(self)
    }
}
enum ActivityType{
    case general
    case textbook(ISBN: String, pages: ClosedRange<Int>)
}
class Activity: Identifiable, ObservableObject, Codable{
    var id: UUID
    public var name: String
    var textbook: Textbook? = .none
    @Published var times: [Double]
    
    @Published var reps: Int = 1
    var color: Color = Color.randomColor()
    
    init(_ n: String){
        name = n
        times = []
        id = UUID()
    }
    enum CodingKeys: String, CodingKey{
        case id, name, textbook, times
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        textbook = try container.decode(Textbook?.self, forKey: .textbook)
        times = try container.decode([Double].self, forKey: .times)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(textbook, forKey: .textbook)
        try container.encode(times, forKey: .times)
    }
    func addTime(_ time: Double) -> Void{
        times.append(time)
    }
    func avgTime() -> Double?{
        switch times.count{
        case 0: return .none
        default: return times.mean()
        }
    }
    func medianTime() -> Double?{
        switch times.count{
        case 0: return .none
        default: return times.median()
        }
    }
    func MADTime() -> Double?{
        switch times.count{
        case 0: return .none
        default: return times.MAD()
        }
    }
    func changeName(_ newName: String) -> Void{
        name = newName
    }
    func formattedTime() -> String? {
        switch times.count{
        case 0: return .none
        default: return "\(Int(avgTime()!)) mins"
        }
    }
    func formattedRecent() -> String {
        return "\(Int(times[times.count - 1])) mins"
    }
    
    func changeReps(_ x: (Int, Int) -> Int) -> Void{
        let y =  x(reps, 1)
        if(y < 1){
            reps = 1
        }
        else{
            reps = x(reps, 1)
        }
    }
}
class User: ObservableObject{
    var name: String
    var type: UserType = .general
    let id: UUID = UUID()
    init(name: String){
        self.name = name
    }
}
class Data: ObservableObject{
    @Published var activities: [Activity]
    @Published var user: User
    
    init(){
        self.activities = []
        user = User(name: "Ayush Raman")
    }
    func totalTime() -> Double {
        activities
            .map {
                ($0.avgTime() ?? 0) * $0.reps.double()
            }
            .reduce(0.0, +)
    }
    func highestTime() -> Double? {
        activities
            .map { ($0.times.max() ?? 0) }
            .max()
    }
}
