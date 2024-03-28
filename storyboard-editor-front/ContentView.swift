//
//  ContentView.swift
//  storyboard-editor-front
//
//  Created by José Puma on 16-02-24.
//

import SwiftUI
import SpriteKit
import SceneKit
import AppKit

class VariableViewModel: ObservableObject {
    @Published var variables: [ScriptVariable] = []

    // Function to update a variable's value
    func updateValue(for variable: ScriptVariable, newValue: Any) {
        if let index = variables.firstIndex(where: { $0.id == variable.id }) {
            var mutableVariable = variables[index]
            mutableVariable.value = newValue
            variables[index] = mutableVariable
        }
    }
}

struct ContentView: View {
    
    func saveFiles(){
        print(selectedScriptFile)
    }
    
    @State var userProjects : [Project] = []
    @State var files : [ScriptFile] = []
    @StateObject var viewModel = VariableViewModel()
    
    @State private var musicPosition: Double = 0
    @State private var frameWidth: Double = 854
    @State private var frameHeight: Double = 480
    @State private var musicPositionTime: String = "00:00:00"
    @State private var zoomSize : Double = 80
    @State private var buttonPlayerStatusText = "Play"
    @State private var selectedEffectName : Effect = Effect(name: "None", filter: CIFilter())
    @StateObject private var contentViewmodel = ContentViewModel()
    @State private var selectedScriptId: UUID?
    @State private var selectedProjectId: UUID?
    @State private var isSwitchOn = false
    @State private var isPopOverCreateProjectOpen = false
    @State var name: String = ""
    @State var backgroundMusicPath: String = ""
    @State var bpm: Double = 0.0
    @State var offset: Double = 0.0
    let screenWidth  = NSScreen.main?.frame.width
    let screenHeight = NSScreen.main?.frame.height
    let iconActionsSize = CGFloat(20)
    
    
    @State var selectedScriptFile : ScriptFile = ScriptFile(name: "", path: "")
    @State var selectedProject : Project = Project()

    var body: some View {
        HStack(alignment: .top, spacing: 0){
            
            //Projects container
            VStack(alignment: .leading, spacing: 0){
                List(selection: $selectedProjectId){
                    Section("My Projects"){
                        ForEach(userProjects) { project in
                            Label(project.name , systemImage: "folder")
                                .badge(
                                    Text("\(String(format: "%.1f", project.bpm)) \(Image(systemName: "metronome"))")
                                )
                        }
                    }
                }
                .navigationTitle("My Projects")
                .listStyle(.sidebar)
            
                Button {
                    isPopOverCreateProjectOpen = true
                }label: {
                    Label("Create New Project", systemImage: "plus")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                }
                .sheet(isPresented: $isPopOverCreateProjectOpen, content: {
                    ProjectCreatorView(name: $name, backgroundMusicPath: $backgroundMusicPath, bpm: $bpm, offset: $offset){
                        let project = Project(name: name, backgroundMusicPath: backgroundMusicPath, bpm: bpm, offset: offset)
                        let newProject = ProjectHandler(project)
                        if newProject.saveProjectSettings(){
                            userProjects.insert(project, at: 0)
                            isPopOverCreateProjectOpen = false
                        }
                    }
                })
                .padding()
                .buttonStyle(.borderedProminent)
                
            }.background(.regularMaterial)
            .frame(width: 240)
            .task(){
                let projectReader = ProjectsReader()
                userProjects = await projectReader.getProjects()
            }
            //Scripts Container
            VStack(alignment: .leading, spacing: 0){
                List(selection: $selectedScriptId){
                    Section("Scripts"){
                        ForEach(files) { file in
                            Label(file.name, systemImage: "wand.and.stars.inverse")
                                .contextMenu{
                                    Button("Open script folder") {
                                        print("It will open \(file.path) in VS Code")
                                   }
                                    Button("Open with VSCode") {
                                        /*NSWorkspace.shared.open([URL(filePath: file.path)], withAppBundleIdentifier: "com.microsoft.VSCode", additionalEventParamDescriptor: nil, launchIdentifiers: nil)*/
                                        print("It will open \(file.path) in VS Code")
                                   }
                                    Button("Delete Script") {
                                        print("It will delete \(file.path)")
                                   }
                                }
                        }.onMove{ from, to in
                            files.move(fromOffsets: from, toOffset: to)
                        }
                    }
                }.onChange(of: selectedScriptId, {
                    var fileToRead = files.first(where: { $0.id == selectedScriptId })!
                    let script = contentViewmodel.currentTargetScene!.scriptsReader!.loadScriptContent(scriptPath: fileToRead.path)
                    fileToRead.content = script.0
                    fileToRead.variables = script.1
                    selectedScriptFile = fileToRead
                })
                .navigationTitle("Scripts")
                
                
            }.background(.regularMaterial)
            .frame(width: 240)
            .task(){
                //files = await contentViewmodel.currentTargetScene!.scriptsReader!.loadScriptsFiles()
            }
            
            VStack(alignment: .leading, spacing: 0){
                List {
                    Section("Properties"){
                        ForEach(selectedScriptFile.variables) { variable in
                            switch variable.type {
                            case "number":
                                if let numberValue = variable.value as? Double {
                                    HStack{
                                        Text(variable.name.capitalizedSentence).frame(maxWidth: .infinity, alignment: .leading)
                                        TextField("0", value: Binding(get: {
                                            numberValue
                                        }, set: { newValue in
                                            viewModel.updateValue(for: variable, newValue: newValue)
                                        }), formatter: NumberFormatter()).frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                }
                            case "boolean":
                                if let boolValue = variable.value as? Bool {
                                    HStack{
                                        Text(variable.name.capitalizedSentence).frame(maxWidth: .infinity, alignment: .leading)
                                        Toggle(isOn: Binding(
                                            get: { boolValue },
                                            set: { newValue in
                                                viewModel.updateValue(for: variable, newValue: newValue)
                                            }
                                        )) {
                                        
                                        }
                                        .toggleStyle(.switch).frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                }
                            case "string":
                                if let stringValue = variable.value as? String {
                                    HStack{
                                        Text(variable.name.capitalizedSentence).frame(maxWidth: .infinity, alignment: .leading)
                                        TextField("Content", text: Binding(get: {
                                            stringValue
                                        }, set: { newValue in
                                            viewModel.updateValue(for: variable, newValue: newValue)
                                        })).frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                }
                            default:
                                EmptyView()
                            }
                        }
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .listStyle(.inset)
                .onAppear {
                    // Populate variables initially
                    selectedScriptFile.variables = selectedScriptFile.variables.map { variable in
                        ScriptVariable(name: variable.name, type: variable.type, value: variable.value)
                    }
                }
                
                
                if selectedScriptFile.variables.count > 0{
                    Button {
                        
                    }label: {
                        Label("Save Changes", systemImage: "wand.and.stars.inverse")
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                }
                
            }.frame(width: 240)
            
            //Main Content
            VStack(spacing: 0){
                //Storyboard Visualizer
                ZStack(alignment: .bottom){
                    SpriteView(scene: contentViewmodel.scene, debugOptions: [.showsFPS, .showsNodeCount, .showsPhysics, .showsQuadCount, .showsFields, .showsDrawCount])
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


extension String {
    var capitalizedSentence: String {
        // 1
        let firstLetter = self.prefix(1).capitalized
        // 2
        let remainingLetters = self.dropFirst()
        // 3
        return firstLetter + remainingLetters
    }
}
