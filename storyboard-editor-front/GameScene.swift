//
//  GameScene.swift
//  storyboard-editor-front
//
//  Created by José Puma on 16-02-24.
//

import SpriteKit
import SwiftUI
import SwiftImageReadWrite

class GameScene : SKScene {
    var textures : [String: SKTexture] = [:]
    var storyboard = Storyboard()
    var sound : Player?
    private var spriteInfoText = SKLabelNode(fontNamed: "Chalkduster")
    override func didMove(to view: SKView) {
        textures = loadTextures(path: "/Users/josepuma/Documents/sprites")
        storyboard.loadTextures(textures: textures)
        
        sound = Player(soundPath: "/Users/josepuma/Documents/sprites/Niicap - Lifeline.mp3")
        //sound?.play()
        let length = sound?.getLength()
        print("\(length ?? 0)")
        
        let bg = Sprite(spritePath: "spark.png")
        storyboard.addSprite(sprite: bg)
        
        spriteInfoText.text = "owo"
        spriteInfoText.fontSize = 200
        spriteInfoText.fontColor = .white
        spriteInfoText.position = CGPoint(x: frame.midX, y: frame.midY)
        
        let sprites = storyboard.getSprites()
        for sprite in sprites {
            addChild(sprite)
        }
        addChild(spriteInfoText)
    }
    
    override func update(_ currentTime: TimeInterval) {
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
    
    private func loadSprites(path: String) -> [String: SKSpriteNode] {
        let fm = FileManager.default
        let finalPath = URL(filePath: path)
        do {
            let items = try fm.contentsOfDirectory(at: finalPath.absoluteURL, includingPropertiesForKeys: nil, options: [])
            var sprites : [String: SKSpriteNode] = [:]
            for item in items {
                if item.pathExtension == "png" || item.pathExtension == "jpeg" || item.pathExtension == "jpg" {
                    let spriteImage = try CGImage.load(fileURL: item)
                    let spriteTexture = SKTexture(cgImage: spriteImage)
                    let sprite = SKSpriteNode(texture: spriteTexture)
                    sprite.position = CGPoint(x: 420 , y: 240)
                    sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                    if item.pathExtension == "jpeg"{
                        sprite.xScale = 0.2
                        sprite.yScale = 0.2
                    }else{
                        sprite.size = CGSize(width: 40, height: 40)
                    }
                    sprite.blendMode = .add
                    sprites[item.lastPathComponent] = sprite
                }
            }
            return sprites
        }catch {
            print(error)
        }
        return [:]
    }
    
}
