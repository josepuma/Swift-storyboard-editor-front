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
        scene.scaleMode = .fill
        currentTargetScene = scene as? StoryboardScene
    }
    
    
    func getAudioPosition(){
        
    }
    
}
