//
//  storyboard_editor_frontApp.swift
//  storyboard-editor-front
//
//  Created by José Puma on 16-02-24.
//

import SwiftUI

@main
struct storyboard_editor_frontApp: App {
    
    //@State private var myObject = CodeFileWriter.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                //.environmentObject(myObject)
        }.commands{
            CommandMenu("Editor"){
                Button("Save Changes") {
                    //CodeFileWriter.shared.writeCode()
                }.keyboardShortcut("s")
            }
        }
    }
}
