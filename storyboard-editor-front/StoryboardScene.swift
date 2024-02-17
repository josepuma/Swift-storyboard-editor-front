//
//  StoryboardScene.swift
//  storyboard-editor-front
//
//  Created by José Puma on 17-02-24.
//

import Foundation
import SpriteKit
import Combine

class StoryboardScene: SKScene, ObservableObject{
    weak var contentViewModal: ContentViewModel?
    public var player : Player!
    @Published var musicPosition : String = "00:00:00"
    public let musicPublisher = CurrentValueSubject<String, Never>("00:00:00")
    private var cancellableSet = Set<AnyCancellable>()
    
    var textures : [String: SKTexture] = [:]
    var storyboard = Storyboard()
    
    override init(){
        super.init(size: CGSize(width: 854, height: 480))
        musicPublisher
            .sink(receiveValue: { [unowned self] target in
                            self.musicPosition = target
                        })
                        .store(in: &cancellableSet)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        textures = loadTextures(path: "/Users/josepuma/Documents/sprites")
        storyboard.loadTextures(textures: textures)
        
        let bg = Sprite(spritePath: "spark.png")
        bg.moveX(startTime: 10, endTime: 10000, startValue: 0, endValue: 854)
        storyboard.addSprite(sprite: bg)
        
        let sprites = storyboard.getSprites()
        for sprite in sprites {
            addChild(sprite)
        }
    }
    
    override func sceneDidLoad() {
        scene?.backgroundColor = .clear
        player = Player(soundPath: "/Users/josepuma/Documents/sprites/Niicap - Lifeline.mp3")
    }
    
    @Published var finalMusicPosition : String = "00:00:00" {
        didSet {
            musicPublisher.send(String(self.musicPosition))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        musicPosition = player.getPositionFormatted()
        finalMusicPosition = self.musicPosition
        let positionTimeLine = player.getPosition()
        if positionTimeLine > 0{
            for sprite in storyboard.getSprites() {
                sprite.update(timePosition: positionTimeLine)
            }
        }
    }
    
    
    func getAudioPosition() -> Double {
        return player.getPosition()
    }
    
    func getAudioLength() -> Double {
        return player.getLength()
    }
    
    func updateAudioPosition(position: Double){
        player.setPosition(position: Int(position))
    }
    
    private func loadTextures(path: String) -> [String: SKTexture]{
        let fm = FileManager.default
        let finalPath = URL(filePath: path)
        do {
            let items = try fm.contentsOfDirectory(at: finalPath.absoluteURL, includingPropertiesForKeys: nil, options: [])
            var sprites : [String: SKTexture] = [:]
            for item in items {
                if item.pathExtension == "png" || item.pathExtension == "jpeg" || item.pathExtension == "jpg" {
                    let spriteImage = try CGImage.load(fileURL: item)
                    let spriteTexture = SKTexture(cgImage: spriteImage)
                    sprites[item.lastPathComponent] = spriteTexture
                }
            }
            return sprites
        }catch {
            print(error)
        }
        return [:]
    }
}
