import SwiftUI

class ScriptVariable : Identifiable, ObservableObject, Equatable {
    static func == (lhs: ScriptVariable, rhs: ScriptVariable) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id = UUID()
    let name: String
    let type: String
    @Published var value: Any
    
    init(name: String, type: String, value: Any){
        self.name = name
        self.type = type
        self.value = value
    }
    
    
    func updateValue(value: Any){
        self.value = value
    }
}
