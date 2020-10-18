//
//  Activity.swift
//  ProCrast
//
//  Created by Ayush Raman on 8/5/20.
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
class Activity: Identifiable, ObservableObject{
    
    var id: UUID
    var deadline: Date
    public var name: String
    @Published var times: Array<Double>
    public var grade: Double?
    @Published var reps: Int = 1
    var color: Color = Color.randomColor()
    
    init(_ n: String){
        name = n
        times = []
        id = UUID()
        deadline = Date()
    }
    func addTime(_ time: Double) -> Void{
        times.append(time)
    }
    func avgTime() -> Double?{
        let y : Double = Double(times.count)
        let x : Double = times.reduce(0.0, { a, b in a + b/y })
        switch times.count{
        case 0: return .none
        default: return x
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
    func formattedGrade() -> String?{
        switch grade{
        case .none: return .none
        default: return "\(grade!)%"
        }
    }
    func changeReps(_ x: (Int, Int) -> Int) -> Void{
        let y =  x(reps, 1)
        
        if(y < 0){
            reps = 0
        }
        else{
            reps = x(reps, 1)
        }
    }
    
}
class Activities: ObservableObject{
    @Published var activities: [Activity]
    init(){
        self.activities = []
    }
    func totalTime() -> Double {
        
        activities
            .map {
                switch $0.avgTime(){
                case .none: return 0
                default: return $0.avgTime()!
                }
                
            }
            .reduce(0.0, +)
    }
}

