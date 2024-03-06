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
        @Binding var selectedScriptFile : ScriptFile
        var body: some View {
            CodeEditor(source: $selectedScriptFile.content, language: .javascript, theme: .atelierSavannaDark,
                       flags: [ .selectable, .editable, .smartIndent ])
            .padding(0)
        }
}
