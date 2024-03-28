//
//  ProjectsReader.swift
//  storyboard-editor-front
//
//  Created by José Puma on 28-03-24.
//

import Foundation
class ProjectsReader {
    
    var projectsPath : String {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path()
    }
    
    func loadJSONData(from filePath: String) throws -> Data {
        return try Data(contentsOf: URL(fileURLWithPath: filePath))
    }
    
    func decodeFromJSON<T: Codable>(_ data: Data, type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(type, from: data)
    }
    
    func getProjects() async -> [Project]{
        var projects: [Project] = []
        let path = URL(fileURLWithPath: "\(projectsPath)/Swtoard")
        do{
            let contents = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: .none)
            for itemURL in contents {
                if itemURL.hasDirectoryPath{
                    let files = try FileManager.default.contentsOfDirectory(atPath: itemURL.path)
                    if files.contains("config.json"){
                        do {
                            let data = try loadJSONData(from: "\(itemURL.path)/config.json")
                            let project = try decodeFromJSON(data, type: Project.self)
                            projects.append(project)
                        }catch{
                            print(error)
                        }
                    }
                }
            }
        }catch{
            print(error)
        }
        return projects
    }
}
