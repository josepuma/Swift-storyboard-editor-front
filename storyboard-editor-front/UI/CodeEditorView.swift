//
//  SpriteContainer.swift
//  storyboard-editor-front
//
//  Created by José Puma on 24-02-24.
//
import SwiftUI
import SpriteKit
import CodeEditor

struct CodeEditorView : View {
        @Binding var script : ScriptFile
        @FocusState private var focused: Bool
    
        var scriptHasBeenSaved: () -> Void
    
        var body: some View {
            CodeEditor(source: $script.content, language: .javascript, theme: .atelierSavannaDark,
                       flags: [ .selectable, .editable, .smartIndent ])
            .focusable()
            .focused($focused)
            .onChange(of: focused, {
                if !focused {
                    scriptHasBeenSaved()
                }
            })
            .onAppear {
                focused = true
            }
        }
}
