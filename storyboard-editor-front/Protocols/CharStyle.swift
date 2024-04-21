//
//  CharStyle.swift
//  storyboard-editor-front
//
//  Created by José Puma on 20-04-24.
//

import JavaScriptCore
import Foundation
import SwiftUI

@objc protocol CharStyleExport : JSExport {
    
    static func create() -> CharStyle
    static func createWithShadow(_ shadowBlurRadius: Int, _ shadowOffsetX: Int, _ shadowOffsetY: Int) -> CharStyle
    func show()
}

@objc public class CharStyle : NSObject, CharStyleExport {
    
    dynamic var color: JSValue?
    dynamic var shadowColor: JSValue?

    var shadowBlurRadius : Int
    var shadowOffsetX : Int
    var shadowOffsetY : Int
    
    var textColor: NSColor {
        var r = 1.0
        var g = 1.0
        var b = 1.0
        if self.color?.isObject != nil{
            if let swiftObject = color?.toObject() as? [String: Any] {
                if let valueR = swiftObject["r"] as? Double {
                    r = valueR / 255.0
                }
                if let valueG = swiftObject["g"] as? Double {
                    g = valueG / 255.0
                }
                if let valueB = swiftObject["b"] as? Double {
                    b = valueB / 255.0
                }
            }
        }
        return NSColor(red: CGFloat(r), green: g, blue: b, alpha: 1)
    }
    
    var textShadowColor: NSColor {
        var r = 1.0
        var g = 1.0
        var b = 1.0
        if self.shadowColor?.isObject != nil{
            if let swiftObject = shadowColor?.toObject() as? [String: Any] {
                if let valueR = swiftObject["r"] as? Double {
                    r = valueR / 255.0
                }
                if let valueG = swiftObject["g"] as? Double {
                    g = valueG / 255.0
                }
                if let valueB = swiftObject["b"] as? Double {
                    b = valueB / 255.0
                }
            }
        }
        return NSColor(red: CGFloat(r), green: g, blue: b, alpha: 1)
    }
    
    init(shadowBlurRadius: Int = 0, shadowOffsetX: Int = 0, shadowOffsetY: Int = 0){
        self.shadowBlurRadius = shadowBlurRadius
        self.shadowOffsetX = shadowOffsetX
        self.shadowOffsetY = shadowOffsetY
    }
    
    static func create() -> CharStyle {
        return CharStyle()
    }
    
    static func createWithShadow(_ shadowBlurRadius: Int, _ shadowOffsetX: Int, _ shadowOffsetY: Int) -> CharStyle {
        return CharStyle(shadowBlurRadius: shadowBlurRadius, shadowOffsetX: shadowOffsetX, shadowOffsetY: shadowOffsetY)
    }
    
    func show(){
        print(textColor)
    }

}
