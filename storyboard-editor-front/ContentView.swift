//
//  ContentView.swift
//  storyboard-editor-front
//
//  Created by José Puma on 16-02-24.
//

import SwiftUI
import SpriteKit
import SceneKit
struct ContentView: View {
    
    //define a scene
    var scene: SKScene{
        let scene = GameScene()
        scene.size = CGSize(width: 854, height: 480)
        scene.scaleMode = .fill
        scene.backgroundColor = .clear
        return scene
    }
    
    var body: some View {
        VStack {
            //Text("Hello, world!")
            SpriteView(scene: scene, options: [.allowsTransparency],
                       debugOptions: [.showsFPS, .showsNodeCount]
            )
                .frame(width: 854, height: 480, alignment: .center)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
        .background(VisualEffectView().ignoresSafeArea())
    }
}

#Preview {
    ContentView()
}
