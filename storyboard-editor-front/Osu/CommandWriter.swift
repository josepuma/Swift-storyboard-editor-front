//
//  CommandWriter.swift
//  storyboard-editor-front
//
//  Created by José Puma on 07-04-24.
//

import Foundation
class CommandWriter{
    
    private var commandsToExport : String = ""
    
    init(_ sprite: Sprite){
        commandsToExport.append("Sprite,\(sprite.layer),\(sprite.origin),\"\(sprite.spritePath)\",320,240\n")
    }
    
    func loadCommand(_commandType: String, _ commands: [Command]){
        for command in commands {
            let startValue = round(command.startValue * 10000) / 10000
            let endValue = round(command.endValue * 10000) / 10000
            if _commandType == "MX"{
                commandsToExport.append(" \(_commandType),\(command.easing.index ?? 0),\(Int(command.startTime)),\(Int(command.endTime)),\(startValue - 107),\(endValue - 107)\n")
            }else{
                commandsToExport.append(" \(_commandType),\(command.easing.index ?? 0),\(Int(command.startTime)),\(Int(command.endTime)),\(startValue),\(endValue)\n")
            }
        }
    }
    
    func load2DCommand(_commandType: String,_ commands: [VectorCommand]){
        for command in commands {
            let startValueX = round(command.startValue.x * 10000) / 10000
            let startValueY = round(command.startValue.y * 10000) / 10000
            let endValueX = round(command.endValue.x * 10000) / 10000
            let endValueY = round(command.endValue.y * 10000) / 10000
            
            if _commandType == "M"{
                commandsToExport.append(" \(_commandType),\(command.easing.index ?? 0),\(Int(command.startTime)),\(Int(command.endTime)),\(startValueX - 107),\(startValueY),\(endValueX - 107),\(endValueY)\n")
            }else{
                commandsToExport.append(" \(_commandType),\(command.easing.index ?? 0),\(Int(command.startTime)),\(Int(command.endTime)),\(startValueX),\(startValueY),\(endValueX),\(endValueY)\n")
            }
            
        }
    }
    
    func load3DCommand(_commandType: String, _ commands: [ThirdDVectorCommand]){
        for command in commands {
            commandsToExport.append(" \(_commandType),\(command.easing.index ?? 0),\(Int(command.startTime)),\(Int(command.endTime)),\(Int(command.startValue.x * 255)),\(Int(command.startValue.y * 255)),\(Int(command.startValue.z * 255)),\(Int(command.endValue.x * 255)),\(Int(command.endValue.y * 255)),\(Int(command.endValue.z * 255))\n")
        }
    }
    
    func toOsb() -> String{
        return commandsToExport
    }

}
