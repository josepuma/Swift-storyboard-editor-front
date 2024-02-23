//
//  MoveXCommand.swift
//  storyboard-editor-front
//
//  Created by José Puma on 17-02-24.
//
import Accelerate
class Command {
    var startTime: Double = 0
    var endTime: Double = 0
    var startValue: Double = 0.0
    var endValue: Double = 0.0
    private var position : Double = 0
    private var interpolation = Interpolation()
    private var duration : Double = 0
    private var easing = Easing.linear
 
    var progress: Double {
        return (position - startTime) / duration
    }
    
    var isActive : Bool {
        if position <= startTime {
            return false
        }
        if endTime <= position {
            return false
        }
        return true
    }
    
    var value: Double {
        if position <= startTime {
            return startValue
        }
        if endTime <= position {
            return endValue
        }
        return interpolation.lerp(startValue, endValue, progress)
    }
    
    init(startTime: Double, endTime: Double, startValue: Double, endValue: Double, easing: Easing = .linear) {
        self.startTime = startTime
        self.endTime = endTime
        self.startValue = startValue
        self.endValue = endValue
        self.duration = endTime - startTime
        self.easing = easing
    }
    
    func valueAt(position: Double) -> Double{
        if position < startTime{
            return valueAtProgress(progress: 0)
        }
        if(endTime < position){
            return valueAtProgress(progress: 1)
        }
        let duration = endTime - startTime
        let progress = duration > 0 ?  easing.getEasingValue(progress: (position - startTime) / duration)  : 0
        return valueAtProgress(progress: progress)
    }
    
    func valueAtProgress(progress: Double) -> Double {
        return startValue + (endValue - startValue) * progress
    }
    
    func setTimePosition(position: Double){
        self.position = position;
    }
}
