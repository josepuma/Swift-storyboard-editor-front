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
        commandsToExport.append("Sprite,Background,Centre,\"\(sprite.spritePath)\",320,240\n")
    }
    
    func loadCommand(_commandType: String, _ commands: [Command]){
        for command in commands {
            var startValue = round(command.startValue * 100) / 100
            var endValue = round(command.endValue * 100) / 100
            if _commandType == "MX"{
                commandsToExport.append(" \(_commandType),\(command.easing.index ?? 0),\(Int(command.startTime)),\(Int(command.endTime)),\(startValue - 107),\(endValue)\n")
            }else{
                commandsToExport.append(" \(_commandType),\(command.easing.index ?? 0),\(Int(command.startTime)),\(Int(command.endTime)),\(startValue),\(endValue)\n")
            }
        }
    }
    
    func load2DCommand(_commandType: String,_ commands: [VectorCommand]){
        for command in commands {
            var startValueX = round(command.startValue.x * 100) / 100
            var startValueY = round(command.startValue.y * 100) / 100
            var endValueX = round(command.endValue.x * 100) / 100
            var endValueY = round(command.endValue.y * 100) / 100
            
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
