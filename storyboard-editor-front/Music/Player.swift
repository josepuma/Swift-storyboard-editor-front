//
//  Player.swift
//  storyboard-editor-front
//
//  Created by José Puma on 16-02-24.
//

import AVFoundation
import SwiftUI


class Player {
    private var soundPath : URL?
    public var player : AVAudioPlayer!
    private var samples: [Float] = []
    
    var projectsPath : String {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path()
    }

    func loadAudio(_ project: Project){
        let path = URL(fileURLWithPath: "\(projectsPath)/Swtoard/\(project.folderPath)/\(project.backgroundMusicPath)")
        let fileExists = FileManager.default.fileExists(atPath: path.path)
        
        if fileExists{
            player = try! AVAudioPlayer(contentsOf: path)
            player.enableRate = true
        }
    }
    
    func play(){
        if player != nil {
            if player.isPlaying{
                player.pause()
            }else{
                player?.play()
                //player.rate = 0.5
            }
        }
    }
    
    func getPosition() -> Double{
        if player != nil{
            return player.currentTime * 1000
        }
        return 0
    }
    
    func getPositionFormatted() -> String{
        //let miliseconds = Int(player.currentTime * 1000)
        if player != nil{
            let seconds = Int(player.currentTime)
            let minutes = seconds / 60
            return String(format:"%02d:%02d", minutes, seconds)
        }
        return ""
    }
    
    func setPosition(position: Int){
        player.currentTime = TimeInterval(position / 1000)
    }
    
    func getLength() -> Double{
        if player != nil{
            return player.duration * 1000
        }
        return 0
    }
    
}
