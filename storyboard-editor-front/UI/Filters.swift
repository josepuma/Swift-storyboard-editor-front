//
//  Filters.swift
//  storyboard-editor-front
//
//  Created by José Puma on 24-02-24.
//
import SwiftUI
struct Effect: Hashable, Identifiable {
    let name: String
    let id = UUID()
    let filter : CIFilter?
}


struct FilterGroup: Identifiable {
    let name: String
    let effects: [Effect]
    let id = UUID()
}
