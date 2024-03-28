//
//  ProjectCreatorView.swift
//  storyboard-editor-front
//
//  Created by José Puma on 28-03-24.
//

import SwiftUI
struct ProjectCreatorView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var name: String
    @Binding var backgroundMusicPath: String
    @Binding var bpm: Double
    @Binding var offset: Double
    var createProject: () -> Void
    @State var inputsAreIncomplete = false
    
    var body: some View {
        let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 3
            formatter.locale = Locale(identifier: "en_US")
        return
            Form{
               
                //CustomTextField(placeholder: "My project", text: $projectName)
                TextField("Name", text: $name, prompt: Text("My Project"))
                TextField("Audio Path", text: $backgroundMusicPath, prompt: Text("audio.mp3"))
                TextField("BPM", value: $bpm, formatter: formatter, prompt: Text("120.5"))
                TextField("Offset(ms)", value: $offset, formatter: formatter, prompt: Text("8654"))
                if inputsAreIncomplete{
                    Text("All fields must be completed")
                        .foregroundStyle(.red)
                }
                
                HStack{
                    Button("Save New Project") {
                        inputsAreIncomplete = false
                        if !name.isEmpty && !backgroundMusicPath.isEmpty && bpm > 0{
                            createProject()
                        }else{
                            inputsAreIncomplete = true
                        }
                    }.buttonStyle(.borderedProminent)
                    Button("Close") {
                        dismiss()
                    }
                }
            }.padding(40)
    }
}

struct ProjectCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectCreatorView(name: .constant(""), backgroundMusicPath: .constant(""), bpm: .constant(0), offset: .constant(0)){
            
        }
    }
}
