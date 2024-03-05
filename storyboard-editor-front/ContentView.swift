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
    @State private var frameWidth: Double = 854
    @State private var frameHeight: Double = 480
    @State private var musicPositionTime: String = "00:00:00"
    @State private var zoomSize : Double = 80
    @State private var buttonPlayerStatusText = "Play"
    @State private var selectedEffectName : Effect = Effect(name: "None", filter: CIFilter())
    @StateObject private var contentViewmodel = ContentViewModel()
    
    let screenWidth  = NSScreen.main?.frame.width
    let screenHeight = NSScreen.main?.frame.height

    var body: some View {
        HStack{
            CodeEditorView()
            .padding()
            ZStack(alignment: .bottom) {
                SpriteView(scene: contentViewmodel.scene, options: [.allowsTransparency],
                           debugOptions: [.showsFPS, .showsDrawCount, .showsNodeCount]
                )
                    .frame(width: (frameWidth * zoomSize) / 100, height: (frameHeight * zoomSize) / 100, alignment: .center)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                HStack{
                    /*Button(buttonPlayerStatusText){
                        contentViewmodel.currentTargetScene?.player.play()
                        buttonPlayerStatusText = ((contentViewmodel.currentTargetScene?.player.player.isPlaying) != nil) ? "Pause" : "Play"
                    }*/
                    Button(action: {
                        contentViewmodel.currentTargetScene?.player.play()
                        buttonPlayerStatusText = (contentViewmodel.currentTargetScene!.player.player.isPlaying) ? "Pause" : "Play"
                    }){
                        Text(buttonPlayerStatusText)
                    }
                    Button("Reload Storyboard"){
                        contentViewmodel.currentTargetScene!.reloadStoryboardScene()
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
                    Button {
                        //frameWidth = screenWidth! > 0 ? Double(screenWidth!) : 854
                        //frameHeight = screenHeight! > 0 ? Double(screenHeight!) : 480
                        //contentViewmodel.scene.size.width = frameWidth
                        //contentViewmodel.scene.size.height  = frameHeight
                        
                        contentViewmodel.scene.view?.window?.collectionBehavior = .fullScreenPrimary
                        contentViewmodel.scene.view?.enterFullScreenMode(.main!)
                    } label: {
                        Image(systemName: "arrow.down.backward.and.arrow.up.forward.square")
                    }.buttonStyle(.borderless)
                }.padding(20)
                    
                
                /*Stepper(
                    value: $zoomSize,
                    in: 10...100,
                    step: 10,
                    onEditingChanged: { editing in
                        contentViewmodel.currentTargetScene!.updateZoomSize(percentage: zoomSize)
                    }
                ){
                    Text("Zoom: \(zoomSize)")
                }*/
            }.frame(width: (frameWidth * zoomSize) / 100)
            //EffectsContainer()
            //    .padding()
        }
        //.background(VisualEffectView().ignoresSafeArea())
    }
}

