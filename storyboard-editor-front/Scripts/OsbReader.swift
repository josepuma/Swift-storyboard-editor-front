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
            for line in lines {
                if(line.starts(with: "//")){ continue }
                if(line.starts(with: "[")){ continue }
                if(line.isEmpty){ continue }
                let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                var values = trimmedLine.components(separatedBy: ",")
                switch(values[0]){
                    case "Sprite" :
                        let path = removePathQuotes(path: values[3].lowercased())
                        let x = Double(values[4])
                        let y = Double(values[5])
                        if(sprite != nil){
                            sprites.append(sprite!)
                            sprite = nil
                        }
                    
                    sprite = Sprite(spritePath: path, position: CGPoint(x: x!, y: y!))
                    
                    default:
                        if(values[3].isEmpty){
                            values[3] = values[2]
                        }
                        let commandType = values[0]
                        let startTime = Double(values[2])
                        let endTime = Double(values[3])
                        switch commandType {
                            case "M":
                                let startX = Double(values[4])! + Double(107)
                                let startY = Double(values[5])
                                let endX = values.count > 6 ? Double(values[6])! + Double(107) : startX
                                let endY = values.count > 7 ? Double(values[7]) : startY
                                sprite?.moveX(startTime: startTime!, endTime: endTime!, startValue: startX, endValue: endX)
                                sprite?.moveY(startTime: startTime!, endTime: endTime!, startValue: startY!, endValue: endY!)
                            case "V":
                                let startX = Double(values[4])
                                let startY = Double(values[5])
                                let endX = values.count > 6 ? Double(values[6]) : startX
                                let endY = values.count > 7 ? Double(values[7]) : startY
                                sprite?.scaleX(startTime: startTime!, endTime: endTime!, startValue: startX!, endValue: endX!)
                                sprite?.scaleY(startTime: startTime!, endTime: endTime!, startValue: startY!, endValue: endY!)
                            case "MX":
                                let startValue = Double(values[4])! + Double(107)
                                let endValue = values.count > 5 ? Double(values[5])! + Double(107) : startValue
                                sprite?.moveX(startTime: startTime!, endTime: endTime!, startValue: startValue, endValue: endValue)
                            case "MY":
                                let startValue = Double(values[4])
                                let endValue = values.count > 5 ? Double(values[5]) : startValue
                                sprite?.moveY(startTime: startTime!, endTime: endTime!, startValue: startValue!, endValue: endValue!)
                            case "F":
                                let startValue = Double(values[4])
                                let endValue = values.count > 5 ? Double(values[5]) : startValue
                                sprite?.fade(startTime: startTime!, endTime: endTime!, startValue: startValue!, endValue: endValue!)
                            case "S":
                                let startValue = Double(values[4])
                                let endValue = values.count > 5 ? Double(values[5]) : startValue
                                sprite?.scale(startTime: startTime!, endTime: endTime!, startValue: startValue!, endValue: endValue!)
                            case "P":
                                var type = values[4]
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
