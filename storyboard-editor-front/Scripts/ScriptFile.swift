//
//  ScriptFile.swift
//  storyboard-editor-front
//
//  Created by José Puma on 28-03-24.
//

import SwiftUI
import JavaScriptCore

class ScriptFile : ObservableObject, Codable, Identifiable, Hashable, Equatable {
    
    var projectsPath : String {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path()
    }
    
    @Published var name: String = ""
    @Published var content: String = ""
    var path: String = ""
    var order : Int = 0
    
    var sprites : [Sprite] = []
    @Published var variables : [ScriptVariable] = []
    
    enum CodingKeys: String, CodingKey {
        case name
        case path
        case order
    }
    
    init(){
        
    }
    
    init(name: String, order: Int = 0) {
        self.name = name
        self.path = "\(name.lowercased()).js"
        self.order = order
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        path = try container.decode(String.self, forKey: .path)
        order = try container.decode(Int.self, forKey: .order)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(path, forKey: .path)
        try container.encode(order, forKey: .order)
    }
    
    static func == (lhs: ScriptFile, rhs: ScriptFile) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func writeScript(project: Project) -> Bool{
        do {
            let path = URL(fileURLWithPath: "\(projectsPath)/Swtoard/\(project.folderPath)/\(self.path)")
            try content.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            return true
        } catch {
            return false
        }
    }
    
    func loadScript(project: Project) -> String{
           do{
               let path = URL(fileURLWithPath: "\(projectsPath)/Swtoard/\(project.folderPath)/\(path)")
               let contents = try String(contentsOfFile: path.path)
               return contents
           }catch {
               print(error)
               return ""
           }
       }
    
    func readScript(project: Project, completion: @escaping(_ spriteArray: [Sprite], _ errorMessage: String) -> Void){
        var sprites: [Sprite] = []
        getSpritesFromScript(){ spriteArray, errorMessage in
            print("finished reading script \(self.name) and found \(spriteArray.count) sprites")
            self.sprites.removeAll()
            self.sprites.append(contentsOf: spriteArray)
            sprites.append(contentsOf: spriteArray)
            completion(spriteArray, errorMessage)
        }
    }
    
    func getSpritesFromScript(completion: @escaping(_ spriteArray: [Sprite], _ errorMessage: String) -> Void) {
        let context = JSContext()
        let sprites: [Sprite] = []
        context?.setObject(Sprite.self, forKeyedSubscript: NSString(string: "Sprite"))
        context?.setObject(Helpers.self, forKeyedSubscript: NSString(string: "Helpers"))
        
        
        
        context?.evaluateScript(content)
        
        // Evaluate the script and check for errors
        context?.exceptionHandler = { context, exception in
            if let exception = exception {
                print(exception)
                completion(sprites, exception.toString())
            }
        }
        
        // Check if an error occurred during script evaluation
        if let error = context?.exception {
            print(error)
            completion(sprites, error.toString())
            return
        }
        
        for variable in variables {
            //context?.setObject(variable.value, forKeyedSubscript: variable.name as NSString)
        }
        
        let generateFunction = context?.objectForKeyedSubscript("generate")
        let spriteArray = generateFunction?.call(withArguments: [sprites]).toArray() as? [Sprite]
        
        spriteArray?.forEach { sprite in
            sprite.setScriptParent(to: self)
        }
        
        completion(spriteArray ?? [], "")
    }
}



struct ScriptSprite {
    var scripts : [ScriptFile] = []
    var sprites : [Sprite] = []
}

