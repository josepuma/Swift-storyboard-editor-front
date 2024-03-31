//
//  ScriptVariableView.swift
//  storyboard-editor-front
//
//  Created by José Puma on 31-03-24.
//

import SwiftUI

struct ScriptVariableView: View {
    @ObservedObject var variable : ScriptVariable
    @FocusState private var isFocused: Bool
   
    var updateScript: () -> Void
    
    var body: some View {
            switch variable.type {
                case "string":
                    TextField(variable.name.capitalizedSentence, text: Binding(get: {
                        variable.value as! String
                    }, set: { newValue in
                        variable.updateValue(value: newValue)
                    })).focused($isFocused)
                    .onChange(of: isFocused, {
                        if !isFocused{
                            updateScript()
                        }
                    })
                case "number":
                    TextField(variable.name.capitalizedSentence, value: Binding(get: {
                        variable.value as? Double
                    }, set: { newValue in
                        variable.updateValue(value: newValue ?? 0)
                    }), formatter: NumberFormatter())
                    .focused($isFocused)
                    .onChange(of: isFocused, {
                        if !isFocused{
                            updateScript()
                        }
                    })
                case "boolean":
                    Toggle(isOn: Binding(
                        get: { variable.value as! Bool },
                        set: { newValue in
                            variable.updateValue(value: newValue)
                            updateScript()
                        }
                    )) {
                        Text(variable.name)
                    }
                    .focused($isFocused)
                    .toggleStyle(.switch)
                default:
                    Text("")
            }
    }
}
