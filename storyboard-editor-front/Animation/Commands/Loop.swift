//
//  Loop.swift
//  storyboard-editor-front
//
//  Created by José Puma on 27-02-24.
//

import Swift
import SpriteKit
class Loop {
    private var fadeCommands : [Command] = []
    private var scaleCommands : [Command] = []
    private var scaleXCommands : [Command] = []
    private var scaleYCommands : [Command] = []
    private var rotateCommands : [Command] = []
    private var moveXCommands : [Command] = []
    private var moveYCommands : [Command] = []
    private var moveCommands : [VectorCommand] = []
    private var startTime : Int
    private var loopCount : Int
    
    var opacityCommands : [Command] {
        var commands : [Command] = []
        var start = startTime
        for _ in 0.until(loopCount){
            var duration = 0.0
            for opacity in fadeCommands {
                duration = opacity.endTime - opacity.startTime
                let endTime = start + Int(duration)
                //print(startTime)
                commands.append(Command(startTime: Double(start), endTime: Double(endTime), startValue: opacity.startValue, endValue: opacity.endValue, easing: opacity.easing))
                start = start + Int(duration)
            }
        }
        return commands
    }
    
    var sizeCommands : [Command] {
        var commands : [Command] = []
        var start = startTime
        for _ in 0.until(loopCount){
            var duration = 0.0
            for size in scaleCommands {
                duration = size.endTime - size.startTime
                let endTime = start + Int(duration)
                //print(size.startValue)
                commands.append(Command(startTime: Double(start), endTime: Double(endTime), startValue: size.startValue, endValue: size.endValue, easing: size.easing))
                start = start + Int(duration)
            }
        }
        return commands
    }
    
    var rotationCommands : [Command] {
        var commands : [Command] = []
        var start = startTime
        for _ in 0.until(loopCount){
            var duration = 0.0
            for command in rotateCommands {
                duration = command.endTime - command.startTime
                let endTime = start + Int(duration)
                //print(size.startValue)
                commands.append(Command(startTime: Double(start), endTime: Double(endTime), startValue: command.startValue, endValue: command.endValue, easing: command.easing))
                start = start + Int(duration)
            }
        }
        return commands
    }
    
    var movingCommands : [VectorCommand] {
        var commands : [VectorCommand] = []
        var start = startTime
        for _ in 0.until(loopCount){
            var duration = 0.0
            for command in moveCommands {
                duration = command.endTime - command.startTime
                let endTime = start + Int(duration)
                //print(size.startValue)
                commands.append(VectorCommand(startTime: Double(start), endTime: Double(endTime), startValue: CGPointMake(command.startValue.x, command.startValue.y), endValue: CGPointMake(command.endValue.x, command.endValue.y), easing: command.easing))
                start = start + Int(duration)
            }
        }
        return commands
    }
    
    var movingXCommands : [Command] {
        var commands : [Command] = []
        var start = startTime
        for _ in 0.until(loopCount){
            var duration = 0.0
            for command in moveXCommands {
                duration = command.endTime - command.startTime
                let endTime = start + Int(duration)
                //print(size.startValue)
                commands.append(Command(startTime: Double(start), endTime: Double(endTime), startValue: command.startValue, endValue: command.endValue, easing: command.easing))
                start = start + Int(duration)
            }
        }
        return commands
    }
    
    var movingYCommands : [Command] {
        var commands : [Command] = []
        var start = startTime
        for _ in 0.until(loopCount){
            var duration = 0.0
            for command in moveYCommands {
                duration = command.endTime - command.startTime
                let endTime = start + Int(duration)
                //print(size.startValue)
                commands.append(Command(startTime: Double(start), endTime: Double(endTime), startValue: command.startValue, endValue: command.endValue, easing: command.easing))
                start = start + Int(duration)
            }
        }
        return commands
    }
    
    var sizeXCommands : [Command] {
        var commands : [Command] = []
        var start = startTime
        for _ in 0.until(loopCount){
            var duration = 0.0
            for command in moveXCommands {
                duration = command.endTime - command.startTime
                let endTime = start + Int(duration)
                //print(size.startValue)
                commands.append(Command(startTime: Double(start), endTime: Double(endTime), startValue: command.startValue, endValue: command.endValue, easing: command.easing))
                start = start + Int(duration)
            }
        }
        return commands
    }
    
    var sizeYCommands : [Command] {
        var commands : [Command] = []
        var start = startTime
        for _ in 0.until(loopCount){
            var duration = 0.0
            for command in moveYCommands {
                duration = command.endTime - command.startTime
                let endTime = start + Int(duration)
                //print(size.startValue)
                commands.append(Command(startTime: Double(start), endTime: Double(endTime), startValue: command.startValue, endValue: command.endValue, easing: command.easing))
                start = start + Int(duration)
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
    
    func scale(startTime: Double, endTime: Double, startValue: Double, endValue: Double, easing: Easing = .linear){
        scaleCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue, easing: easing))
    }
    
    func rotate(startTime: Double, endTime: Double, startValue: Double, endValue: Double, easing: Easing = .linear){
        rotateCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue, easing: easing))
    }
    
    func moveX(startTime: Double, endTime: Double, startValue: Double, endValue: Double, easing: Easing = .linear){
        moveXCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue, easing: easing))
    }
    
    func moveY(startTime: Double, endTime: Double, startValue: Double, endValue: Double, easing: Easing = .linear){
        moveYCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue, easing: easing))
    }
    
    
    func scaleX(startTime: Double, endTime: Double, startValue: Double, endValue: Double, easing: Easing = .linear){
        scaleXCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue, easing: easing))
    }
    
    func scaleY(startTime: Double, endTime: Double, startValue: Double, endValue: Double, easing: Easing = .linear){
        scaleYCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue, easing: easing))
    }
    
    func move(startTime: Double, endTime: Double, startValue: CGPoint, endValue: CGPoint, easing: Easing = .linear){
        moveCommands.append(VectorCommand(startTime: startTime, endTime: endTime, startValue: CGPointMake(startValue.x, startValue.y), endValue: CGPointMake(endValue.x, endValue.y), easing: easing))
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
