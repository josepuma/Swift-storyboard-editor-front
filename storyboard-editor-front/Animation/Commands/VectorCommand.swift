//
//  MoveXCommand.swift
//  storyboard-editor-front
//
//  Created by José Puma on 17-02-24.
//
import Accelerate
import SpriteKit
class VectorCommand {
    var startTime: Double = 0
    var endTime: Double = 0
    var startValue: CGPoint = CGPoint(x: 0, y:0)
    var endValue: CGPoint = CGPoint(x: 0, y:0)
    private var position : Double = 0
    private var interpolation = Interpolation()
    //var value : Double = 0
    
    var duration: Double {
        return endTime - startTime
    }
    
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
    
    
    var value: CGPoint {
        if position <= startTime {
            return startValue
        }
        if endTime <= position {
            return endValue
        }
        
        return interpolation.lerp(startValue, endValue, progress)
    }
    
    init(startTime: Double, endTime: Double, startValue: CGPoint, endValue: CGPoint) {
        self.startTime = startTime
        self.endTime = endTime
        self.startValue = startValue
        self.endValue = endValue
    }
    
    func valueAt(position: Double) -> CGPoint{
        if position < startTime{
            return valueAtProgress(progress: 0)
        }
        if(endTime < position){
            return valueAtProgress(progress: 1)
        }
        let duration = endTime - startTime
        let progress = duration > 0 ? (position - startTime) / duration : 0
        return valueAtProgress(progress: progress)
    }
    
    func valueAtProgress(progress: Double) -> CGPoint {
        return interpolation.lerp(startValue, endValue, progress)
    }
    
    func setTimePosition(position: Double){
        self.position = position;
    }
}
