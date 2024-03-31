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
    
    @State private var projectSelection: Project?
    
    @State private var projectId: Project.ID?
    
    
    var body : some View {
        
        NavigationSplitView {
            VStack{
                
                if userProjects.count > 0{
                    List(userProjects, selection: $projectSelection){ project in
                        NavigationLink(value: project){
                            Label(project.name , systemImage: "folder")
                            .badge(
                                Text("\(String(format: "%.1f", project.bpm)) \(Image(systemName: "metronome"))")
                            )
                        }
                    }
                    .navigationTitle("My Projects")
                }else{
                    ContentUnavailableView {
                        Label("No Projects Created", systemImage: "folder.badge.plus")
                    } description: {
                        Text("New projects will be found here.")
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
            }
            
        } detail: {
            if let project = projectSelection {
                ScriptManagementView(project: project)
                    .navigationTitle(project.name)
           } else {
               Text("Choose a Project to start creating")
           }
        }
        .task(){
            let projectReader = ProjectsReader()
            userProjects = await projectReader.getProjects()
        }

    }
}


struct ProjectManagementView_Preview : PreviewProvider{
    static var previews : some View {
        ProjectManagementView()
    }
}
