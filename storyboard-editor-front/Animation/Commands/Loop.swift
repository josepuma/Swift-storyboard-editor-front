//
//  Loop.swift
//  storyboard-editor-front
//
//  Created by José Puma on 27-02-24.
//

import Swift

class Loop {
    private var fadeCommands : [Command] = []
    private var startTime : Int
    private var loopCount : Int
    
    var opacityCommands : [Command] {
        var commands : [Command] = []
        for i in 0.until(loopCount){
            var duration = 0.0
            for opacity in fadeCommands {
                duration = opacity.endTime - opacity.startTime
                let endTime = startTime + Int(duration)
                print(startTime)
                commands.append(Command(startTime: Double(startTime), endTime: Double(endTime), startValue: opacity.startValue, endValue: opacity.endValue, easing: opacity.easing))
                startTime = startTime + Int(duration)
            }
        }
        return commands
    }
    
    init(startTime: Int, loopCount: Int){
        self.startTime = startTime
        self.loopCount = loopCount
    }
    
    func fade(startTime: Double, endTime: Double, startValue: Double, endValue: Double, easing: Easing = .linear){
        fadeCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue, easing: easing))
        
    }
}

extension Int {
  func until(_ end: Int) -> CountableRange<Int> {
    return self <= end ? self..<end : self..<self
  }

  func through(_ end: Int) -> CountableRange<Int> {
    return self <= end ? self..<(end + 1) : self..<self
  }
}
