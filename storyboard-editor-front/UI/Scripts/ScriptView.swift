//
//  ScriptVariableView.swift
//  storyboard-editor-front
//
//  Created by José Puma on 31-03-24.
//

import SwiftUI

struct ScriptView: View {
    @ObservedObject var script : ScriptFile
    @ObservedObject var project : Project
    @FocusState private var isFocused: Bool
    var updateScript: ([Sprite]) -> Void
    
    var body: some View {
        ForEach(script.variables){ variable in
            ScriptVariableView(variable: variable){
                DispatchQueue.main.async {
                    script.readScript(project: project){spriteArray in
                        updateScript(spriteArray)
                    }
                }
            }
        }
    }
}
