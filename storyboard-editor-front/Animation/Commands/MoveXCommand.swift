//
//  MoveXCommand.swift
//  storyboard-editor-front
//
//  Created by José Puma on 17-02-24.
//
import Accelerate
class MoveXCommand {
    var startTime: Double = 0
    var endTime: Double = 0
    var startValue: Double = 0.0
    var endValue: Double = 0.0
    private var position : Double = 0
    
    var duration: Double {
        return endTime - startTime
    }
    
    var progress: Double {
        return (position - startTime) / duration
    }
    
    var value: Double {
        if position <= startTime {
            return startValue
        }
        if endTime <= position {
            return endValue
        }
        return vDSP.linearInterpolate([startValue], [endValue], using: progress)[0]
    }
    
    init(startTime: Double, endTime: Double, startValue: Double, endValue: Double) {
        self.startTime = startTime
        self.endTime = endTime
        self.startValue = startValue
        self.endValue = endValue
    }
    
    func setTimePosition(position: Double){
        //print(position)
        self.position = position;
    }
}
