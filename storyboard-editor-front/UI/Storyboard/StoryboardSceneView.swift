//
//  StoryboardSceneView.swift
//  storyboard-editor-front
//
//  Created by José Puma on 30-03-24.
//

import SwiftUI
struct StoryboardSceneView: View{
    @State var sprites : [Sprite]
    var body: some View{
        Text(sprites.count.formatted())
    }
}

