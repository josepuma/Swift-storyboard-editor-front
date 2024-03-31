//
//  ScriptManagementView.swift
//  storyboard-editor-front
//
//  Created by José Puma on 28-03-24.
//

import SwiftUI
import CodeEditor

struct ScriptManagementView : View {
    @ObservedObject var project : Project
    @State private var isPopOverCreateScriptOpen = false
    @State private var textValue = ""
    @State private var selectedScript : ScriptFile = ScriptFile()
    @State private var isProjectLoading = true
    
    @State private var sprites : [Sprite] = []
    
    var body: some View {
        HStack(spacing: 0){
            
            if isProjectLoading{
                ProgressView(label: {
                    Text("Loading Project")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                ).progressViewStyle(.circular)
            }else{
                VStack{
                    List(project.scripts) { script in
                        DisclosureGroup(
                            content: {
                                Form {
                                    TextField("SpritePath", text: $textValue, prompt: Text("bg.jpg"))
                                }
                            },label :{
                                HStack(){
                                    HStack{
                                        Label(script.name , systemImage: "bubbles.and.sparkles")
                                    }
                                    Spacer()
                                    Button{
                                        let content = script.readScript(project: project)
                                        script.content = content
                                        selectedScript = script
                                    } label: {
                                        Image(systemName: "chevron.left.forwardslash.chevron.right")
                                    }.buttonStyle(.plain)
                                    Button{
                                        
                                    } label: {
                                        Image(systemName: "trash")
                                    }.buttonStyle(.plain)
                                    .foregroundColor(.red)
                                }
                                    
                            }
                        )
                    }
                    Button {
                        isPopOverCreateScriptOpen = true
                    }label: {
                        Label("Create New Script", systemImage: "plus")
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    }.buttonStyle(.borderedProminent)
                    .sheet(isPresented: $isPopOverCreateScriptOpen, content: {
                        ScriptCreatorView {scriptName in
                            let script = ScriptFile(name: scriptName, order: project.scripts.count + 1)
                            project.scripts.append(script)
                            
                            let projectToSave = ProjectHandler(project)
                            if projectToSave.saveProjectSettings(){
                                isPopOverCreateScriptOpen = false
                            }
                        }
                    })
                    .padding()
                }.frame(maxWidth: 320)
                
                
                VStack{
                    StoryboardSceneView(sprites: sprites)
                        .frame(maxWidth: .infinity)
                    CodeEditorView(script: $selectedScript){
                        if selectedScript.writeScript(project: project){
                            print("script saved")
                        }
                    }
                }
            }
            
            
        }.task(id: project) {
            DispatchQueue.main.async {
                let code = CodeFileReader(project)
                code.loadScripts { spriteArray in
                    sprites.append(contentsOf: spriteArray)
                    isProjectLoading = false
                }
            }
        }.onChange(of: project, {
            sprites.removeAll()
            isProjectLoading = true
        })
    }
}

struct ScriptManagement_Preview : PreviewProvider{
    static var previews: some View{
        let project = Project(name: "Holi", folderPath: "", backgroundMusicPath: "", bpm: 0, scripts: [ ScriptFile(name: "Background") ])
        ScriptManagementView(project: project)
    }
}
