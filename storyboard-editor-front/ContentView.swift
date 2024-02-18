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
    @State private var musicPositionTime: String = "00:00:00"
    @StateObject private var contentViewmodel = ContentViewModel()

    var body: some View {
        VStack {
            
            HStack{
                Button("Play"){
                    contentViewmodel.currentTargetScene?.player.play()
                }
                Button("View Position"){
                    contentViewmodel.getAudioPosition()
                }
                Text("\(musicPositionTime)")
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
                    }
                    .onReceive(contentViewmodel.currentTargetScene!.musicPublisher, perform: { target in
                        musicPositionTime = target
                    })
                    .onReceive(contentViewmodel.currentTargetScene!.musicTimePublisher, perform: { target in
                        musicPosition = target
                    })
                   
                }
            }
            SpriteView(scene: contentViewmodel.scene, options: [.allowsTransparency],
                       debugOptions: [.showsFPS, .showsDrawCount, .showsNodeCount]
            )
                .frame(width: 1708, height: 960, alignment: .center)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
        .background(VisualEffectView().ignoresSafeArea())
    }
}

#Preview {
    ContentView()
}
