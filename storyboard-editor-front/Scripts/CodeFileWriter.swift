//
//  CodeFileWriter.swift
//  storyboard-editor-front
//
//  Created by José Puma on 06-03-24.
//

import Foundation
class CodeFileWriter : ObservableObject{
    static let shared = CodeFileWriter()
    static var script : ScriptFile = ScriptFile(name: "", path: "")
    func writeCode(){
        do {
            let file = URL(filePath: CodeFileWriter.script.path)
            try CodeFileWriter.script.content.write(to: file, atomically: true, encoding: String.Encoding.utf8)
            print("code saved")
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
    }
}
