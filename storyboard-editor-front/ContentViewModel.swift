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
        scene.size = CGSize(width: 854, height: 480)
        scene.anchorPoint = CGPoint(x: 0, y: 1)
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .black
        
        currentTargetScene = scene as? StoryboardScene
    }
    
    func applyFilter(filter: Effect){
        
        if(filter.name == "None"){
            scene.shouldRasterize = false
            scene.shouldEnableEffects = false
            return
        }
        
        scene.filter = filter.filter
        scene.shouldRasterize = true
        scene.shouldEnableEffects = true
    }
    
    
    func getAudioPosition(){
        
    }
    
}
