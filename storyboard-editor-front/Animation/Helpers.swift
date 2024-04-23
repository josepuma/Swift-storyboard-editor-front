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
    static func GenerateRandomInt(_ startValue: Int, _ endValue : Int) -> Int
    static func GetSprites(_ osbPath: String) -> [Sprite]
    static func Print(_ content: String)
}

class Helpers : NSObject, HelpersExport {
    
    static func GenerateRandom(_ startValue: Double, _ endValue: Double) -> Double {
        if(startValue == endValue){
            return startValue
        }
        return Double.random(in: startValue ..< endValue)
    }
    
    static func GenerateRandomInt(_ startValue: Int, _ endValue: Int) -> Int {
        if(startValue == endValue){
            return startValue
        }
        return Int.random(in: startValue ..< endValue)
    }
    
    static func GetSprites(_ osbPath: String) -> [Sprite]{
        let osbReader = OsbReader(osbPath: osbPath)
        return osbReader.spriteList
    }
    
    static func Print(_ content: String){
        print(content)
    }
    
}
