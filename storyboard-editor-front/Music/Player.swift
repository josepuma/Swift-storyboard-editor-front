//
//  Player.swift
//  storyboard-editor-front
//
//  Created by José Puma on 16-02-24.
//

import AVFoundation

class Player {
    private var soundPath : URL?
    private var player : AVAudioPlayer!
    init(soundPath : String){
        self.soundPath = URL(fileURLWithPath: soundPath);
        player = try! AVAudioPlayer(contentsOf: self.soundPath!)

    }
    
    func play(){
        player?.play()
    }
    
    func getPosition() -> Double{
        return player.currentTime * 1000
    }
    
    func setPosition(position: Int){
        player.currentTime = TimeInterval(position / 1000)
    }
    
    func getLength() -> Double{
        return player.duration * 1000
    }
    
}
