//
//  ContentViewModel.swift
//  storyboard-editor-front
//
//  Created by José Puma on 17-02-24.
//

import Combine
import Foundation
import SpriteKit

class ContentViewModel : ObservableObject {
    var currentTargetScene: StoryboardScene?
    var scene: SKScene
    
    init(){
        scene = StoryboardScene()
        let  blur = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": 20])
        //scene.size = CGSize(width: 1708, height: 960)
        scene.anchorPoint = CGPoint(x: 0, y: 1)
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .clear
        //scene.filter = blur
        //scene.shouldRasterize = true
        //scene.shouldEnableEffects = true
        currentTargetScene = scene as? StoryboardScene
    }
    
    
    func getAudioPosition(){
        
    }
    
}
