//
//  SpriteOrigin.swift
//  storyboard-editor-front
//
//  Created by José Puma on 18-02-24.
//
import SpriteKit
enum SpriteOrigin : String{
    case topLeft,centre, centreLeft, topRight, bottomCentre, topCentre, custom, centreRight, bottomLeft, bottomRight
    var anchorPoint : CGPoint {
        switch(self){
            case .topLeft:
                    return CGPoint(x: 0, y: 1)
            case .centre:
                    return CGPoint(x: 0.5, y: 0.5)
            case .centreLeft:
                return CGPoint(x: 0, y: 0.5)
            case .topRight:
                    return CGPoint(x: 1, y: 1)
            case .bottomCentre:
                return CGPoint(x: 0.5, y: 0)
            case .topCentre:
                    return CGPoint(x: 0.5, y: 1)
            case .custom:
                return CGPoint(x: 0.5, y: 0.5)
            case .centreRight:
                    return CGPoint(x: 1, y: 0.5)
            case .bottomLeft:
                    return CGPoint(x: 0, y: 0)
            case .bottomRight:
                    return CGPoint(x: 1, y: 0)
        }
    }
}
