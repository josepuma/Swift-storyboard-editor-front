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
    @State private var music: Double = 0
    @StateObject private var contentViewmodel = ContentViewModel()
    //define a scene
    /*var scene: SKScene{
        let scene = GameScene()
        scene.size = CGSize(width: 854, height: 480)
        scene.scaleMode = .fill
        scene.backgroundColor = .clear
        return scene
    }*/
    
    var body: some View {
        VStack {
            
            HStack{
                Button("Play"){
                    contentViewmodel.currentTargetScene?.player.play()
                }
                Button("View Position"){
                    contentViewmodel.getAudioPosition()
                }
                Text("Position: \(music)")
                VStack{
                    Slider(
                        value: Binding(get: {
                           musicPosition
                        }, set: {
                            (newVal) in
                            musicPosition = newVal
                            contentViewmodel.currentTargetScene?.updateAudioPosition(position: musicPosition)
                        }),
                        in: 0...(contentViewmodel.currentTargetScene?.getAudioLength())!
                    ){
                    }.onReceive(contentViewmodel.currentTargetScene!.musicPublisher, perform: { target in
                        print(target)
                    })
                }
            }
            SpriteView(scene: contentViewmodel.scene, options: [.allowsTransparency],
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
