//
//  ProjectHandler.swift
//  storyboard-editor-front
//
//  Created by José Puma on 27-03-24.
//

import Foundation
class ProjectHandler{
    
    var project : Project
    
    init(_ project: Project){
        self.project = project
    }
    
    private func encodeToJSON<T: Codable>(_ object: T)throws -> Data{
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(object)
    }
    
    private func saveJSONData(_ data: Data, to folderName: String, fileName: String) -> Bool {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error: Unable to access Documents Directory.")
            return false
        }
        
        let folderURL = documentsDirectory.appendingPathComponent(folderName)
        let fileURL = folderURL.appendingPathComponent(fileName)
        
        // Create the folder if it doesn't exist
        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating folder: \(error)")
            return false
        }
        
        // Write the JSON data to the file
        do {
            try data.write(to: fileURL)
            print("JSON file saved successfully at: \(fileURL)")
            return true
        } catch {
            print("Error saving JSON file: \(error)")
            return false
        }
    }
    
    func saveProjectSettings() -> Bool{
        do{
            let jsonData = try encodeToJSON(project)
            return saveJSONData(jsonData, to: "Swtoard/\(project.name.capitalized)", fileName: "config.json")
        }catch{
            return false
        }
    }
}
