//
//  OsbReader.swift
//  storyboard-editor-front
//
//  Created by José Puma on 17-02-24.
//
import Foundation
import SpriteKit
class OsbReader {
    private var osbPath = ""
    private var sprites : [Sprite] = []
    private var textLines : [String] = []
    
    init(osbPath: String){
        self.osbPath = osbPath
        readLines()
    }
    
    var spriteList : [Sprite] {
        return self.sprites
    }
    
    private func readLines(){
        do {
            let contents = try String(contentsOfFile: osbPath)
            let lines = contents.components(separatedBy: "\n")
            var sprite: Sprite?
            var loop: Loop?
            var loopStartTime = 0
            var loopRepetitions = 0
            for line in lines {
                if(line.starts(with: "//")){ continue }
                if(line.starts(with: "[")){ continue }
                if(line.isEmpty){ continue }
                let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                var values = trimmedLine.components(separatedBy: ",")
                let isPartOfLoop = line.starts(with: "  ")
                switch(values[0]){
                    case "Sprite" :
                        let path = removePathQuotes(path: values[3])
                        let origin = values[2].camelCased
                        let x = Double(values[4])
                        let y = Double(values[5])
                        if(sprite != nil){
                            sprites.append(sprite!)
                            sprite = nil
                        }
                    
                    sprite = Sprite(spritePath: path, position: CGPoint(x: x!, y: y!), origin: SpriteOrigin(rawValue: origin)!)
                    case "T":
                        break;
                    case "Animation":
                    
                        break;
                    case "L":
                        /*loopStartTime = Int(values[1])!;
                        loopRepetitions = Int(values[2])!;
                        print("L")
                        if(loop != nil){
                            for command in loop!.opacityCommands{
                                //print(command.startTime, command.endTime, command.startValue, command.endValue)
                                sprite?.fade(startTime: command.startTime, endTime: command.endTime, startValue: command.startValue, endValue: command.endValue, easing: command.easing)
                            }
                            loop = nil
                        }
                        loop = Loop(startTime: loopStartTime, loopCount: loopRepetitions)*/
                        sprite = nil
                        break;
                    default:
                        if(values[3].isEmpty){
                            values[3] = values[2]
                        }
                        let commandType = values[0]
                        let startTime = Double(values[2])
                        let endTime = Double(values[3])
                        let commandDuration = Int(endTime!) - Int(startTime!)
                        switch commandType {
                            case "M":
                                let easing = Int(values[1])! < 13 ? Easing.allCases[Int(values[1])!] : .linear
                                let startX = Double(values[4])! + Double(107)
                                let startY = Double(values[5])
                                let endX = values.count > 6 ? Double(values[6])! + Double(107) : startX
                                let endY = values.count > 7 ? Double(values[7]) : startY
                                sprite?.move(startTime: startTime!, endTime: endTime!, startValue: CGPoint(x: startX, y: startY!), endValue: CGPoint(x: endX, y: endY!), easing: easing)
                            case "V":
                                let easing = Int(values[1])! < 13 ? Easing.allCases[Int(values[1])!] : .linear
                                let startX = Double(values[4])
                                let startY = Double(values[5])
                                let endX = values.count > 6 ? Double(values[6]) : startX
                                let endY = values.count > 7 ? Double(values[7]) : startY
                                sprite?.scaleX(startTime: startTime!, endTime: endTime!, startValue: startX!, endValue: endX!, easing: easing)
                                sprite?.scaleY(startTime: startTime!, endTime: endTime!, startValue: startY!, endValue: endY!, easing: easing)
                            case "MX":
                            let easing = Int(values[1])! < 13 ? Easing.allCases[Int(values[1])!] : .linear
                                let startValue = Double(values[4])! + Double(107)
                                let endValue = values.count > 5 ? Double(values[5])! + Double(107) : startValue
                                sprite?.moveX(startTime: startTime!, endTime: endTime!, startValue: startValue, endValue: endValue, easing: easing)
                            case "MY":
                                let easing = Int(values[1])! < 13 ? Easing.allCases[Int(values[1])!] : .linear
                                let startValue = Double(values[4])
                                let endValue = values.count > 5 ? Double(values[5]) : startValue
                                sprite?.moveY(startTime: startTime!, endTime: endTime!, startValue: startValue!, endValue: endValue!, easing: easing)
                            case "F":
                                let easing = Int(values[1])! < 13 ? Easing.allCases[Int(values[1])!] : .linear
                                let startValue = Double(values[4])
                                let endValue = values.count > 5 ? Double(values[5]) : startValue
                                if isPartOfLoop{
                                    loop?.fade(startTime: startTime!, endTime: endTime!, startValue: startValue!, endValue: endValue!, easing: easing)
                                    }else{
                                        sprite?.fade(startTime: startTime!, endTime: endTime!, startValue: startValue!, endValue: endValue!, easing: easing)
                                    }
                                
                            case "S":
                                let easing = Int(values[1])! < 13 ? Easing.allCases[Int(values[1])!] : .linear
                                let startValue = Double(values[4])
                                let endValue = values.count > 5 ? Double(values[5]) : startValue
                                sprite?.scale(startTime: startTime!, endTime: endTime!, startValue: startValue!, endValue: endValue!, easing: easing)
                            case "R":
                                let easing = Int(values[1])! < 13 ? Easing.allCases[Int(values[1])!] : .linear
                                let startValue = Double(values[4])
                                let endValue = values.count > 5 ? Double(values[5]) : startValue
                                sprite?.rotate(startTime: startTime!, endTime: endTime!, startValue: startValue!, endValue: endValue!, easing: easing)
                            case "C":
                                let easing = Int(values[1])! < 13 ? Easing.allCases[Int(values[1])!] : .linear
                                let startX = Double(values[4])
                                let startY = Double(values[5])
                                let startZ = Double(values[6])
                                let endX = values.count > 7 ? Double(values[7]) : startX
                                let endY = values.count > 8 ? Double(values[8]) : startY
                                let endZ = values.count > 9 ? Double(values[9]) : startZ
                                sprite?.color(r: startX! / 255, g: startY! / 255, b: startZ! / 255, easing: easing)
                            case "P":
                                let type = values[4]
                                switch type {
                                    case "A":
                                        sprite?.blendMode = .add
                                    default:
                                        sprite?.blendMode = .alpha
                                }
                            default:
                            break;
                        }
                    }
            }
        }catch {
            print(error)
        }
    }
    
    private func removePathQuotes(path: String) -> String {
        return path.replacingOccurrences(of: "\"", with: "")
    }
    
}

extension String {
    var lowercasingFirst: String { prefix(1).lowercased() + dropFirst() }
    var uppercasingFirst: String { prefix(1).uppercased() + dropFirst() }

    var camelCased: String {
        guard !isEmpty else { return "" }
        let parts = components(separatedBy: .alphanumerics.inverted)
        let first = parts.first!.lowercasingFirst
        let rest = parts.dropFirst().map { $0.uppercasingFirst }

        return ([first] + rest).joined()
    }
}

