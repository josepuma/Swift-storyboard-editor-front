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
    
    var projectsPath : String {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path()
    }
    private var project : Project
    
    init(_ project: Project){
        self.project = project
    }
    
    func receivedNotification(_ notification: SFSMonitorNotification, url: URL, queue: SFSMonitor) {
    
        // Place actions into a utility-level Dispatch Queue.
        // Remember to call UI updates from DispatchQueue.main.async blocks.
        /*monitorDispatchQueue.async(flags: .barrier) { // Multithread protection
            print("\(notification.toStrings().map { $0.rawValue }) @ \(url.path)")
        }*/
    }
    
    /*func loadScriptsFiles() async -> [ScriptFile]{
        let fm = FileManager.default
        var scriptsFilesPath : [ScriptFile] = []
        do {
            let scripts = try fm.contentsOfDirectory(atPath: self.scriptsPath)
            for script in scripts {
                if URL(filePath: script).pathExtension == "js"{
                    let contents = try String(contentsOfFile: self.scriptsPath + "/" + script)
                    let variables = getVariablesFromScript(code: contents)
                    scriptsFilesPath.append(
                        ScriptFile(name: (script as NSString).deletingPathExtension.uppercasingFirst, path: self.scriptsPath + "/" + script, variables: variables)
                    )
                }
            }
            
        }catch{
            
        }
        return scriptsFilesPath
    }*/
    
    func loadScriptContent(scriptPath: String) -> (String, [ScriptVariable]) {
        do{
            let contents = try String(contentsOfFile: scriptPath)
            let variables = getVariablesFromScript(code: contents)
            return (contents, variables)
        }catch {
            print(error)
        }
        return ("", [])
    }

    func loadScripts(completion: @escaping(_ spriteArray: [Sprite]) -> Void){
        var sprites: [Sprite] = []
        do {
            for script in project.scripts {
                let path = URL(fileURLWithPath: "\(projectsPath)/Swtoard/\(project.folderPath)/\(script.path)")
                let contents = try String(contentsOfFile: path.path)
    
                //let variables = getVariablesFromScript(code: contents)
                /*scriptsFiles.append(
                    ScriptFile(name: script.uppercasingFirst, path: self.scriptsPath + "/" + script, variables: variables)
                )*/
                getSpritesFromScript(code: contents){ spriteArray in
                    print("finished reading script \(script) and found \(spriteArray.count) sprites")
                    sprites.append(contentsOf: spriteArray)
                }
            }
            completion(sprites)
        }catch{
            
        }
    }
    
    func getVariablesFromScript(code: String) -> [ScriptVariable]{
        var variables : [ScriptVariable] = []
        let context = JSContext()
        context?.evaluateScript(code)
        
        // Access dynamically created variables (excluding functions and classes)
        if let globalObject = context?.globalObject {
            // Convert global object to dictionary
            if let globalDict = globalObject.toDictionary() {
                // Iterate over keys of the global object
                for propertyName in globalDict.keys.sorted(by: { "\($0)" < "\($1)" }) {
                    // Check if the property is not a function or class
                    if let propertyValue = globalDict[propertyName] {
                        let valueType = context?.evaluateScript("typeof \(propertyName)").toString()
                        if valueType != "function" && valueType != "object" {
                            // Convert boolean strings to boolean values
                            let value: Any
                            if valueType == "boolean" {
                                value = Int(String(describing: propertyValue)) == 0 ? false : true
                            } else {
                                value = propertyValue
                            }
                            variables.append(
                                ScriptVariable(name: String(describing: propertyName), type: valueType!, value: value)
                            )
                            //print("Value of variable \(propertyName): \(value) and type \(valueType)")
                        }
                    }
                }
            }
        } else {
            print("Global object is undefined")
        }
        
        return variables
    }
    
    func getSpritesFromScript(code: String, completion: @escaping(_ spriteArray: [Sprite]) -> Void){
        let context = JSContext()
        let sprites : [Sprite] = []
        context?.setObject(Sprite.self, forKeyedSubscript: NSString(string: "Sprite"))
        context?.setObject(Helpers.self, forKeyedSubscript: NSString(string: "Helpers"))
        context?.evaluateScript(code)
        
        let generateFunction = context?.objectForKeyedSubscript("generate")
        let response = generateFunction?.call(withArguments: [sprites]).toArray() as? [Sprite]
        context?.evaluateScript(code)

        
        completion(response ?? [])
    }
}

/*struct ScriptFile : Identifiable {
    let name: String
    let path: String
    var content: String = ""
    var variables: [ScriptVariable] = []
    let id = UUID()
}

struct ScriptVariable : Identifiable {
    let id = UUID()
    let name: String
    let type: String
    var value: Any
}


struct ScriptSprite {
    var scripts : [ScriptFile]
    var sprites : [Sprite]
}*/
