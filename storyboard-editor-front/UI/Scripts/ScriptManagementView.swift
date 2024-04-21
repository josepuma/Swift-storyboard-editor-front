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
    @State private var errorMessages = "Errors will be shown here"
    @State private var isEditorHidden = false
    @State private var sprites : [Sprite] = []
    @StateObject private var contentViewmodel = ContentViewModel()
    
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
                    if(!isEditorHidden){
                        List(project.scripts) { script in
                            DisclosureGroup(
                                content: {
                                    Form {
                                        ScriptView(script: script, project: project){ spriteArray in
                                            DispatchQueue.main.async {
                                                contentViewmodel.currentTargetScene?.loadSprites(spriteArray, script: selectedScript)
                                            }
                                        }
                                    }
                                },label: {
                                    HStack(){
                                        HStack{
                                            Label(script.name , systemImage: "bubbles.and.sparkles")
                                        }
                                        Spacer()
                                        Button{
                                            let content = script.loadScript(project: project)
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
                        
                        
                    }
                }.frame(maxWidth: isEditorHidden ? 0 : 320)
                
                
                VStack(spacing: 0){
                    StoryboardSceneView(sprites: sprites, project: project, contentViewmodel: contentViewmodel){
                        isEditorHidden = !isEditorHidden
                    }.frame(maxWidth: .infinity)
                    if(!isEditorHidden){
                        CodeEditorView(script: $selectedScript){
                            if selectedScript.writeScript(project: project){
                                DispatchQueue.main.async {
                                    selectedScript.getSpritesFromScript(){spriteArray, errorMessage in
                                        errorMessages = errorMessage
                                        contentViewmodel.currentTargetScene?.loadSprites(spriteArray, script: selectedScript)
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    
                    
                    
                    if !errorMessages.isEmpty{
                        Text(errorMessages)
                            .font(.subheadline)
                            .foregroundStyle(.red)
                            .fontDesign(.monospaced)
                    }
                }
            }
            
            
        }.task(id: project) {
            DispatchQueue.main.async {
                
                project.loadTextures()
                
                let code = CodeFileReader(project)
                Store.textures = project.textures
                code.loadScripts { spriteArray in
                    sprites.append(contentsOf: spriteArray)
                    contentViewmodel.currentTargetScene?.player.loadAudio(project)
                    contentViewmodel.currentTargetScene?.loadTexturesSprites(textures: project.textures, sprites: sprites)
                    isProjectLoading = false
                }
            }
        }.onChange(of: project, {
            selectedScript = ScriptFile()
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
