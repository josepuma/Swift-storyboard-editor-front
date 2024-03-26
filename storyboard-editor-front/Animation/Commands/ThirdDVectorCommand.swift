//
//  ThirdDVectorCommand.swift
//  storyboard-editor-front
//
//  Created by José Puma on 17-02-24.
//
import Accelerate
import SpriteKit
import simd

class ThirdDVectorCommand {
    var startTime: Double = 0
    var endTime: Double = 0
    var startValue: SIMD3 = SIMD3<Double>(x: 1, y: 1, z: 1)
    var endValue: SIMD3 = SIMD3<Double>(x: 1, y: 1, z: 1)
    private var position : Double = 0
    private var interpolation = Interpolation()
    var easing = Easing.linear
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
    
    
    var value: SIMD3<Double> {
        if position <= startTime {
            return startValue
        }
        if endTime <= position {
            return endValue
        }
        
        return interpolation.lerp3D(startValue, endValue, progress)
    }
    
    init(startTime: Double, endTime: Double, startValue: SIMD3<Double>, endValue: SIMD3<Double>, easing: Easing) {
        self.startTime = startTime
        self.endTime = endTime
        self.startValue = startValue
        self.endValue = endValue
        self.easing = easing
    }
    
    func valueAt(position: Double) -> SIMD3<Double>{
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
    
    func valueAtProgress(progress: Double) -> SIMD3<Double> {
        return interpolation.lerp3D(startValue, endValue, progress)
    }
    
    func setTimePosition(position: Double){
        self.position = position;
    }
}
