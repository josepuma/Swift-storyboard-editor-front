//
//  Project.swift
//  storyboard-editor-front
//
//  Created by José Puma on 27-03-24.
//

import Foundation

struct Project: Codable, Identifiable{
    
    var id = UUID()
    var name: String = ""
    var folderPath: String = ""
    var backgroundMusicPath: String = ""
    var bpm: Double = 0
    var offset: Double = 0
    var version: Double = 1.0
    var createdAt: Date = Date()
}
