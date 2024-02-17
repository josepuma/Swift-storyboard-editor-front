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
    
    @State private var musicPosition: Double = 0
    
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
            HStack{
                VStack{
                    Slider(
                        value: $musicPosition,
                        in: 0...1000,
                        step: 10
                    ){
                        Text("\(musicPosition)")
                    }
                }
            }
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
