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
    
    func saveFiles(){
        print(selectedScriptFile)
    }
    
    @State var files : [ScriptFile] = []
    
    @State private var musicPosition: Double = 0
    @State private var frameWidth: Double = 854
    @State private var frameHeight: Double = 480
    @State private var musicPositionTime: String = "00:00:00"
    @State private var zoomSize : Double = 80
    @State private var buttonPlayerStatusText = "Play"
    @State private var selectedEffectName : Effect = Effect(name: "None", filter: CIFilter())
    @StateObject private var contentViewmodel = ContentViewModel()
    @State private var selectedScriptId: UUID?
    
    let screenWidth  = NSScreen.main?.frame.width
    let screenHeight = NSScreen.main?.frame.height
    let iconActionsSize = CGFloat(20)
    
    
    @State var selectedScriptFile : ScriptFile = ScriptFile(name: "", path: "")

    var body: some View {
        HStack(alignment: .top, spacing: 0){
            //Sidebar Container
            VStack(alignment: .leading){
                List(selection: $selectedScriptId){
                    Section("Scripts"){
                        ForEach(files) { file in
                            Label(file.name, systemImage: "wand.and.stars.inverse")
                        }
                    }
                }.onChange(of: selectedScriptId, {
                    var fileToRead = files.first(where: { $0.id == selectedScriptId })!
                    fileToRead.content = contentViewmodel.currentTargetScene!.scriptsReader!.loadScriptContent(scriptPath: fileToRead.path)
                    selectedScriptFile = fileToRead
                })
                .navigationTitle("Scripts")
                    .listStyle(.sidebar)
                
            }.background(.regularMaterial)
            .frame(width: 240)
            .task(){
                files = await contentViewmodel.currentTargetScene!.scriptsReader!.loadScriptsFiles()
            }
            
            //Main Content
            VStack(spacing: 0){
                //Storyboard Visualizer
                ZStack(alignment: .bottom){
                    SpriteView(scene: contentViewmodel.scene)
                    HStack{
                        Button{
                            contentViewmodel.currentTargetScene?.player.play()
                            buttonPlayerStatusText = (contentViewmodel.currentTargetScene!.player.player.isPlaying) ? "Pause" : "Play"
                        } label: {
                            if(contentViewmodel.currentTargetScene!.player.player.isPlaying){
                                Image(systemName: "pause.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: iconActionsSize, height: iconActionsSize)
                            }else{
                                Image(systemName: "play.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: iconActionsSize, height: iconActionsSize)
                            }
                            
                        }.buttonStyle(.borderless)
                            .foregroundColor(.white)
                    
                        Button{
                            contentViewmodel.currentTargetScene!.reloadStoryboardScene()
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath.circle.fill" )
                                .resizable()
                                .scaledToFit()
                                .frame(width: iconActionsSize, height: iconActionsSize)
                        }.buttonStyle(.borderless)
                            .foregroundColor(.white)

                        
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
                        }).accentColor(.white)
                        
                        
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
                //Code Editor
                CodeEditorView(selectedScriptFile: $selectedScriptFile)
            }
            
        }.frame(maxWidth: .infinity, alignment: .leading)
            .onChange(of: selectedScriptFile.content, {
                CodeFileWriter.script = selectedScriptFile
            })

    }
}

