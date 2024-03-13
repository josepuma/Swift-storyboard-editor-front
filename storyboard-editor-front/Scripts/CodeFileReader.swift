//
//  CodeFileReader.swift
//  storyboard-editor-front
//
//  Created by José Puma on 04-03-24.
//

import Foundation
import JavaScriptCore
import SFSMonitor
class CodeFileReader : SFSMonitorDelegate {
    let monitorDispatchQueue =  DispatchQueue(label: "monitorDispatchQueue", qos: .utility)
        
       
    
    private var scriptsPath: String
    private var scriptsFiles : [ScriptFile] = []
    public var scripts : [String: String] = [:]
    
    init(_ scriptsPath: String){
        self.scriptsPath = scriptsPath
    }
    
    func receivedNotification(_ notification: SFSMonitorNotification, url: URL, queue: SFSMonitor) {
    
        // Place actions into a utility-level Dispatch Queue.
        // Remember to call UI updates from DispatchQueue.main.async blocks.
        monitorDispatchQueue.async(flags: .barrier) { // Multithread protection
            print("\(notification.toStrings().map { $0.rawValue }) @ \(url.path)")
        }
    }
    
    func loadScriptsFiles() async -> [ScriptFile]{
        let fm = FileManager.default
        var scriptsFilesPath : [ScriptFile] = []
        do {
            let scripts = try fm.contentsOfDirectory(atPath: self.scriptsPath)
            for script in scripts {
                if URL(filePath: script).pathExtension == "js"{
                    scriptsFilesPath.append(
                        ScriptFile(name: (script as NSString).deletingPathExtension.uppercasingFirst, path: self.scriptsPath + "/" + script)
                    )
                }
            }
            
        }catch{
            
        }
        return scriptsFilesPath
    }
    
    func loadScriptContent(scriptPath: String) -> String {
        do{
            let contents = try String(contentsOfFile: scriptPath)
            return contents
        }catch {
            print(error)
        }
        return ""
    }

    func loadScripts(completion: @escaping(_ spriteArray: ScriptSprite) -> Void){
        let fm = FileManager.default
        var sprites: [Sprite] = []
        do {
            let scripts = try fm.contentsOfDirectory(atPath: self.scriptsPath)
            for script in scripts {
                if URL(filePath: script).pathExtension == "js"{
                    let contents = try String(contentsOfFile: self.scriptsPath + "/" + script)
                    self.scripts[script] = contents
                    scriptsFiles.append(
                        ScriptFile(name: script.uppercasingFirst, path: self.scriptsPath + "/" + script)
                    )
                    getSpritesFromScript(code: contents){ spriteArray in
                        print("finished reading script \(script) and found \(spriteArray.count) sprites")
                        sprites.append(contentsOf: spriteArray)
                    }
                }
            }
            completion(ScriptSprite(scripts: scriptsFiles, sprites: sprites))
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
    var content: String = ""
    let id = UUID()
}


struct ScriptSprite {
    var scripts : [ScriptFile]
    var sprites : [Sprite]
}
