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
    private var displaySize : Double = 2
    public var player : Player!
    @Published var musicPosition : String = "00:00:00"
    @Published var musicPositionTime : Double = 0
    public let musicPublisher = CurrentValueSubject<String, Never>("00:00:00")
    public let musicTimePublisher = CurrentValueSubject<Double, Never>(0)
    private var cancellableSet = Set<AnyCancellable>()
    private var renderSprites: [Sprite] = []
    var textures : [String: SKTexture] = [:]
    var storyboard = Storyboard()
    var osbReader : OsbReader?
    
    override init(){
        super.init(size: CGSize(width: 1708, height: 960))
        musicPublisher
            .sink(receiveValue: { [unowned self] target in
                            self.musicPosition = target
                        })
                        .store(in: &cancellableSet)
        musicTimePublisher
            .sink(receiveValue: { [unowned self] target in
                            self.musicPositionTime = target
                        })
                        .store(in: &cancellableSet)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        textures = loadTextures(path: "/Users/josepuma/Downloads/547714 RADWIMPS - Hikari/sb")
        storyboard.loadTextures(textures: textures)
        
        osbReader = OsbReader(osbPath: "/Users/josepuma/Downloads/547714 RADWIMPS - Hikari/RADWIMPS - Hikari (Haruto).osb")
        storyboard.addSprites(sprites: osbReader!.spriteList)
        
        renderSprites = storyboard.getSprites()
        for sprite in renderSprites {
            addChild(sprite)
        }
    }
    
    override func sceneDidLoad() {
        scene?.backgroundColor = .clear
        player = Player(soundPath: "/Users/josepuma/Downloads/547714 RADWIMPS - Hikari/audio.mp3")
    }
    
    @Published var finalMusicPosition : String = "00:00:00" {
        didSet {
            musicPublisher.send(String(self.musicPosition))
        }
    }
    
    @Published var finalMusicPositionTime : Double = 0 {
        didSet {
            musicTimePublisher.send(self.musicPositionTime)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        musicPosition = player.getPositionFormatted()
        finalMusicPosition = self.musicPosition
        musicPositionTime = player.getPosition()
        finalMusicPositionTime = player.getPosition()
        let positionTimeLine = player.getPosition()
        for sprite in renderSprites {
            sprite.update(timePosition: positionTimeLine, displaySize: displaySize)
        }
    }
    
    func updateZoomSize(percentage: Double){
        displaySize = (percentage / 100) * 2
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

struct Global {
    static var soundPosition : Double = 0
}
