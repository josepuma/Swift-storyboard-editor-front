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
    
    func getPositionFormatted() -> String{
        //let miliseconds = Int(player.currentTime * 1000)
        let seconds = Int(player.currentTime)
        let minutes = seconds / 60
        return String(format:"%02d:%02d", minutes, seconds)
    }
    
    func setPosition(position: Int){
        player.currentTime = TimeInterval(position / 1000)
    }
    
    func getLength() -> Double{
        return player.duration * 1000
    }
    
}