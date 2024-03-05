//
//  SpriteContainer.swift
//  storyboard-editor-front
//
//  Created by José Puma on 24-02-24.
//
import SwiftUI
import SpriteKit
import CodeEditorView
import LanguageSupport
struct CodeEditorView : View {
        @State private var text: String = "My awesome code..."
        @State private var position: CodeEditor.Position       = CodeEditor.Position()
        @State private var messages: Set<TextLocated<Message>> = Set()
        @Environment(\.colorScheme) private var colorScheme: ColorScheme
        @State private var showMinimap: Bool = true
        @State private var wrapText: Bool = true
        @FocusState private var editorIsFocused: Bool

        var body: some View {
            VStack{
                CodeEditor(text: $text,
                                 position: $position,
                                 messages: $messages,
                                 language: .swift(),
                                 layout: CodeEditor.LayoutConfiguration(showMinimap: showMinimap, wrapText: wrapText))
                        .environment(\.codeEditorTheme,
                                     colorScheme == .dark ? Theme.defaultDark : Theme.defaultLight)
                        .focused($editorIsFocused)
            }
            
        }
}
