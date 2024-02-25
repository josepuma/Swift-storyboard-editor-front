//
//  Helpers.swift
//  storyboard-editor-front
//
//  Created by José Puma on 24-02-24.
//

import SwiftUI
import JavaScriptCore

@objc protocol HelpersExport: JSExport {
    static func GenerateRandom(_ startValue: Double, _ endValue : Double) -> Double
}

class Helpers : NSObject, HelpersExport {
    static func GenerateRandom(_ startValue: Double, _ endValue: Double) -> Double {
        return Double.random(in: startValue ..< endValue)
    }
    
    
}
