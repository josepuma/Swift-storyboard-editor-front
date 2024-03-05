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
struct SpriteContainer : View {
        private let filterGroups: [FilterGroup] = [
            FilterGroup(name: "Filters",
                        effects: [
                            Effect(name: "None", filter: CIFilter()),
                            Effect(name: "CIGaussianBlur", filter: CIFilter(name: "CIGaussianBlur")!),
                            Effect(name: "CIGloom", filter: CIFilter(name: "CIGloom", parameters: ["inputIntensity": 0.8, "inputRadius": 10])!),
                            Effect(name: "CIKaleidoscope", filter: CIFilter(name: "CIKaleidoscope", parameters: [:])!)])
        ]

        @Binding var selectedEffectName: Effect
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
                /*List() {
                    ForEach(filterGroups) { group in
                        Section(header: Text("\(group.name)")) {
                            ForEach(group.effects) { effect in
                                Button(action: {
                                    selectedEffectName = effect
                                }){
                                    Text(effect.name)
                                }
                            }
                        }
                    }
                }
                
                Text("Selected Effect \(selectedEffectName.name)")*/
            }
            
        }
}
