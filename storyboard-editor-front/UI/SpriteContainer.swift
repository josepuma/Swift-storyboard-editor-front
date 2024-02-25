//
//  SpriteContainer.swift
//  storyboard-editor-front
//
//  Created by José Puma on 24-02-24.
//
import SwiftUI
import SpriteKit
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


        var body: some View {
            VStack{
                List() {
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
                .navigationTitle("Oceans and Seas")
                Text("Selected Effect \(selectedEffectName.name)")
            }
            
        }
}
