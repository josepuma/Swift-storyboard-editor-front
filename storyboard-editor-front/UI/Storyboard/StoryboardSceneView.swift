//
//  StoryboardSceneView.swift
//  storyboard-editor-front
//
//  Created by José Puma on 30-03-24.
//

import SwiftUI
import SpriteKit
import SceneKit

struct StoryboardSceneView: View{
    @State var sprites : [Sprite]
    
    @State var project : Project
    let screenWidth  = NSScreen.main?.frame.width
    let screenHeight = NSScreen.main?.frame.height
    let iconActionsSize = CGFloat(20)
    @State private var buttonPlayerStatusText = "Play"
    @State private var musicPosition: Double = 0
    @State private var musicPositionTime: String = "00:00:00"
    
    @StateObject private var contentViewmodel = ContentViewModel()
    
    var body: some View{
        VStack{
            ZStack(alignment: .bottom){
                SpriteView(scene: contentViewmodel.scene, debugOptions: [.showsFPS, .showsNodeCount, .showsPhysics, .showsQuadCount, .showsFields, .showsDrawCount])
                HStack{
                    Button{
                        contentViewmodel.currentTargetScene?.player.play()
                        //buttonPlayerStatusText = (contentViewmodel.currentTargetScene!.player.player.isPlaying) ? "Pause" : "Play"
                    } label: {
                        Text("Play")
                        /*if(contentViewmodel.currentTargetScene!.player.player.isPlaying){
                            Image(systemName: "pause.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: iconActionsSize, height: iconActionsSize)
                        }else{
                            Image(systemName: "play.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: iconActionsSize, height: iconActionsSize)
                        }*/
                        
                    }.buttonStyle(.borderless)
                        .foregroundColor(.white)
                    
                    Button{
                        //contentViewmodel.currentTargetScene!.reloadStoryboardScene()
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath.circle.fill" )
                            .resizable()
                            .scaledToFit()
                            .frame(width: iconActionsSize, height: iconActionsSize)
                    }.buttonStyle(.borderless)
                        .foregroundColor(.white)
                    
                    
                    /*Slider(
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
                    }).accentColor(.white)*/
                    
                    
                    Button {
                        contentViewmodel.scene.view?.window?.collectionBehavior = .fullScreenPrimary
                        contentViewmodel.scene.view?.enterFullScreenMode(.main!)
                    } label: {
                        Image(systemName: "arrow.down.backward.and.arrow.up.forward.square.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: iconActionsSize, height: iconActionsSize)
                    }.buttonStyle(.borderless)
                        .foregroundColor(.white)
                        .help("View your storyboard in full screen")
                }.padding()
            }
        }.onAppear(){
            contentViewmodel.currentTargetScene?.player.loadAudio(project)
            contentViewmodel.currentTargetScene?.loadTexturesSprites(textures: project.textures, sprites: sprites)
        }
    }
}
