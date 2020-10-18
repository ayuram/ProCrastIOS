//
//  AppModel.swift
//  ProCrast
//
//  Created by Ayush Raman on 8/6/20.
//  Copyright © 2020 Answer Key. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Combine
struct Configuration: Codable, Equatable {
    public let title : String
    private let contents: [[Int]]

    public init(title: String, contents: [[Int]]) throws {
        self.title = title
        self.contents = contents
    }
}

class StopWatch: ObservableObject {
    private var sourceTimer: DispatchSourceTimer?
    private let queue = DispatchQueue(label: "stopwatch.timer")
    private var counter: Int = 0
    public var hasStarted = false
    var stopWatchTime = "00:00:00" {
        didSet {
            self.update()
        }
    }
    
    var paused = true {
        didSet {
            self.update()
        }
    }
    
    var laps = [LapItem]() {
        didSet {
            self.update()
        }
    }
    
    private var currentLaps = [LapItem]() {
        didSet {
            self.laps = currentLaps.reversed()
        }
    }
    func time() -> Double{
        (Double(counter) / 60)/60
    }
    func start() {
        self.paused = false
        hasStarted = true
        guard let _ = self.sourceTimer else {
            self.startTimer()
            return
        }
        
        self.resumeTimer()
    }
    
    func pause() {
        self.paused = true
        self.sourceTimer?.suspend()
    }
    
    func lap() {
        if let firstLap = self.laps.first {
            let difference = self.counter - firstLap.count
            self.currentLaps.append(LapItem(count: self.counter, diff: difference))
        } else {
            self.currentLaps.append(LapItem(count: self.counter))
        }
    }
    
    func reset() {
        self.stopWatchTime = "00:00:00"
        self.counter = 0
        hasStarted = false
        self.pause()
        
    }
    
    func update() {
        objectWillChange.send()
    }
    
    func isPaused() -> Bool {
        return self.paused
    }
    
    private func startTimer() {
        self.sourceTimer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.strict,
                                                          queue: self.queue)
        
        self.resumeTimer()
    }
    
    private func resumeTimer() {
        self.sourceTimer?.setEventHandler {
            self.updateTimer()
        }
        
        self.sourceTimer?.schedule(deadline: .now(),
                                   repeating: 0.0001)
        self.sourceTimer?.resume()
    }
    
    private func updateTimer() {
        self.counter += 1
        
        DispatchQueue.main.async {
            self.stopWatchTime = StopWatch.convertCountToTimeString(counter: self.counter)
        }
    }
}

extension StopWatch {
    struct LapItem {
        let uuid = UUID()
        let count: Int
        let stringTime: String
        
        init(count: Int, diff: Int = -1) {
            self.count = count
            
            if diff < 0 {
                self.stringTime = StopWatch.convertCountToTimeString(counter: count)
            } else {
                self.stringTime = StopWatch.convertCountToTimeString(counter: diff)
            }
        }
    }
}

extension StopWatch {
    static func convertCountToTimeString(counter: Int) -> String {
        let millseconds = counter % 100
        let seconds = counter / 100
        let minutes = seconds / 60
        let hours = minutes / 60
        
        var millsecondsString = "\(millseconds)"
        var secondsString = "\(seconds)"
        var minutesString = "\(minutes)"
        var hoursString = "\(hours)"
        
        if millseconds < 10 {
            millsecondsString = "0" + millsecondsString
        }
        if hours < 10{
            hoursString = "0" + hoursString
        }
        
        if seconds < 10 {
            secondsString = "0" + secondsString
        }
        
        if minutes < 10 {
            minutesString = "0" + minutesString
        }
        
        return "\(hoursString):\(minutesString):\(secondsString)"
    }
}

