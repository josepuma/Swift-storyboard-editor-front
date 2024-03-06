//
//  CodeFileReader.swift
//  storyboard-editor-front
//
//  Created by José Puma on 04-03-24.
//

import Foundation
import JavaScriptCore
class CodeFileReader {
    private var scriptsPath: String
    public var scripts : [String: String] = [:]
    
    init(_ scriptsPath: String){
        self.scriptsPath = scriptsPath
    }

    func loadScripts(completion: @escaping(_ spriteArray: [Sprite]) -> Void){
        let fm = FileManager.default
        var sprites: [Sprite] = []
        do {
            let scripts = try fm.contentsOfDirectory(atPath: self.scriptsPath)
            for script in scripts {
                let contents = try String(contentsOfFile: self.scriptsPath + "/" + script)
                self.scripts[script] = contents
                getSpritesFromScript(code: contents){ spriteArray in
                    print("finished reading script \(script) and found \(spriteArray.count) sprites")
                    sprites.append(contentsOf: spriteArray)
                }
            }
            completion(sprites)
        }catch{
            
        }
    }
    
    func getSpritesFromScript(code: String, completion: @escaping(_ spriteArray: [Sprite]) -> Void){
        let context = JSContext()
        let sprites : [Sprite] = []
        context?.setObject(Sprite.self, forKeyedSubscript: NSString(string: "Sprite"))
        context?.setObject(Helpers.self, forKeyedSubscript: NSString(string: "Helpers"))
        context!.evaluateScript(code)
        let generateFunction = context?.objectForKeyedSubscript("generate")
        let response = generateFunction?.call(withArguments: [sprites]).toArray() as? [Sprite]
        completion(response ?? [])
    }
}

struct ScriptFile : Identifiable {
    let name: String
    let path: String
    var content: String
    let id = UUID()
}
