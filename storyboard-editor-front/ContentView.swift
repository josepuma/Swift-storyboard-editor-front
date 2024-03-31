//
//  ContentView.swift
//  storyboard-editor-front
//
//  Created by José Puma on 16-02-24.
//

import SwiftUI
import SpriteKit
import SceneKit

struct ContentView: View {
    


    var body: some View {
        HStack(alignment: .top, spacing: 0){
            //Projects container
            ProjectManagementView()
        }.frame(maxWidth: .infinity, alignment: .leading)

    }
    
}

struct ConteView_Preview : PreviewProvider{
    static var previews: some View {
        ContentView()
    }
}

