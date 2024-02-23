//
//  Easing.swift
//  storyboard-editor-front
//
//  Created by José Puma on 23-02-24.
//
import SpriteKit
import SwiftUI

enum Easing : CaseIterable {
    case linear, easingOut, easingIn, quadIn, quadOut, quadInout, cubicIn, cubicOut, cubicInOut, quartIn, quartOut, quartInOut, quintIn
    
    func getEasingValue(progress: Double) -> Double{
        switch self {
        case .linear:
            return progress
        case .easingOut:
            return -progress * (progress - 2)
        case .easingIn:
            return progress * progress
        case .quadIn:
            return progress
        case .quadOut:
            return progress
        case .quadInout:
            return progress
        case .cubicIn:
            return progress
        case .cubicOut:
            return progress
        case .cubicInOut:
            return progress
        case .quartIn:
            return progress
        case .quartOut:
            return progress
        case .quartInOut:
            return progress
        case .quintIn:
            return progress
        }
    }
}
