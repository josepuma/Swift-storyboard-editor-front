//
//  OsbReader.swift
//  storyboard-editor-front
//
//  Created by José Puma on 17-02-24.
//
import Foundation
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
            let lines = contents.split(separator: "\n")
            var sprite: Sprite?
            for line in lines {
                if(line.starts(with: "//")){ continue }
                if(line.starts(with: "[")){ continue }
                let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                var values = trimmedLine.components(separatedBy: ",")
                switch(values[0]){
                    case "Sprite" :
                        let path = removePathQuotes(path: values[3].lowercased())
                        //let x = Double(values[4])
                        //let y = Double(values[5])
                        if(sprite != nil){
                            sprites.append(sprite!)
                            sprite = nil
                        }
                    
                        sprite = Sprite(spritePath: path)
                    
                    default:
                        if(values[3].isEmpty){
                            values[3] = values[2]
                        }
                        let commandType = values[0]
                        let startTime = Double(values[2])
                        let endTime = Double(values[3])
                        switch commandType {
                            case "M":
                                let startX = Double(values[4])! + Double(127)
                                let startY = Double(values[5])
                                let endX = values.count > 6 ? Double(values[6])! + Double(127) : startX
                                let endY = values.count > 7 ? Double(values[7]) : startY
                                sprite?.moveX(startTime: startTime!, endTime: endTime!, startValue: startX, endValue: endX)
                                sprite?.moveY(startTime: startTime!, endTime: endTime!, startValue: startY!, endValue: endY!)
                            case "MX":
                                let startValue = Double(values[4])! + Double(127)
                                let endValue = values.count > 5 ? Double(values[5])! + Double(127) : startValue
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
                            default:
                                print("")
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
