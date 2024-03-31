//
//  ScriptCreatorView.swift
//  storyboard-editor-front
//
//  Created by José Puma on 30-03-24.
//

import SwiftUI

struct ScriptCreatorView: View {
    @State var name = ""
    @Environment(\.dismiss) private var dismiss
    var createScript: (String) -> Void
    @State var inputsAreIncomplete = false
    
    var body: some View {
        Form {
            TextField("Name", text: $name, prompt: Text("Sparkles"))
            if inputsAreIncomplete{
                Text("All fields must be completed")
                    .foregroundStyle(.red)
            }
            HStack{
                Button("Save New Script") {
                    inputsAreIncomplete = false
                    if !name.isEmpty{
                        createScript(name)
                    }else{
                        inputsAreIncomplete = true
                    }
                }.buttonStyle(.borderedProminent)
                Button("Close") {
                    dismiss()
                }
            }
        }.padding(40)
            .onSubmit {
                inputsAreIncomplete = false
                if !name.isEmpty{
                    createScript(name)
                }else{
                    inputsAreIncomplete = true
                }
            }
    }
}
