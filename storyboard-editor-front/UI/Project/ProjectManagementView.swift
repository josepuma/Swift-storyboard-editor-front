//
//  ProjectManagementView.swift
//  storyboard-editor-front
//
//  Created by José Puma on 28-03-24.
//

import SwiftUI

struct ProjectManagementView: View {
    
    @State var userProjects : [Project] = []
    @State private var selectedProjectId: UUID?
    @State private var isPopOverCreateProjectOpen = false
    
    
    
    @State var name: String = ""
    @State var backgroundMusicPath: String = ""
    @State var bpm: Double = 0.0
    @State var offset: Double = 0.0
    
    var loadProject : () -> Void
    
    var body : some View {
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
            .onChange(of: selectedProjectId){
                if let selectedProject = userProjects.first(where: { $0.id == selectedProjectId }) {
                    // Handle selected project
                    let projectsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                    if let folderPath = projectsPath?.appendingPathComponent("Swtoard/\(selectedProject.folderPath)"){
                        print(folderPath.path)
                    }

                }
            }
        
            Button {
                isPopOverCreateProjectOpen = true
            }label: {
                Label("Create New Project", systemImage: "plus")
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            }
            .sheet(isPresented: $isPopOverCreateProjectOpen, content: {
                ProjectCreatorView(name: $name, backgroundMusicPath: $backgroundMusicPath, bpm: $bpm, offset: $offset){
                    let project = Project(name: name, folderPath: name.capitalized, backgroundMusicPath: backgroundMusicPath, bpm: bpm, offset: offset)
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
    }
}

struct ProjectManagementView_Preview : PreviewProvider{
    static var previews : some View {
        ProjectManagementView(){}
    }
}
