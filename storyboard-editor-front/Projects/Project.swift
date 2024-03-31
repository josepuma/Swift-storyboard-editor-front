//
//  Project.swift
//  storyboard-editor-front
//
//  Created by José Puma on 27-03-24.
//

import Foundation

class Project: Codable, Identifiable, Hashable, Equatable, ObservableObject{
    
    var id = UUID()
    @Published var name: String = ""
    var folderPath: String = ""
    var backgroundMusicPath: String = ""
    var bpm: Double = 0
    var offset: Double = 0
    var version: Double = 1.0
    var createdAt: Date = Date()
    @Published var scripts: [ScriptFile] = []
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Project, rhs: Project) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case folderPath
        case backgroundMusicPath
        case bpm
        case offset
        case version
        case createdAt
        case scripts
    }
    
    init() {
        
    }
    
    init(name: String, folderPath: String, backgroundMusicPath: String, bpm: Double, offset: Double = 0, scripts: [ScriptFile] = []){
        self.name = name
        self.folderPath = folderPath
        self.backgroundMusicPath = backgroundMusicPath
        self.bpm = bpm
        self.offset = offset
        self.scripts = scripts
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        folderPath = try container.decode(String.self, forKey: .folderPath)
        backgroundMusicPath = try container.decode(String.self, forKey: .backgroundMusicPath)
        bpm = try container.decode(Double.self, forKey: .bpm)
        offset = try container.decode(Double.self, forKey: .offset)
        version = try container.decode(Double.self, forKey: .version)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        scripts = try container.decode([ScriptFile].self, forKey: .scripts)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(folderPath, forKey: .folderPath)
        try container.encode(backgroundMusicPath, forKey: .backgroundMusicPath)
        try container.encode(bpm, forKey: .bpm)
        try container.encode(offset, forKey: .offset)
        try container.encode(version, forKey: .version)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(scripts, forKey: .scripts)
    }
}
