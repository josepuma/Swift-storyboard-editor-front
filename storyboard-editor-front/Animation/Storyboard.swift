//
//  Storyboard.swift
//  storyboard-editor-front
//
//  Created by José Puma on 16-02-24.
//
import SpriteKit
class Storyboard {
    
    private var sprites : [Sprite] = []
    private var textures : [String: SKTexture] = [:]
    
    func loadTextures(textures: [String: SKTexture]){
        self.textures = textures
    }
    
    func addSprite(sprite: Sprite){
        sprite.loadTexture(texture: self.textures[sprite.spritePath]!)
        sprites.append(sprite)
    }
    
    func getSprites() -> [Sprite]{
        return self.sprites
    }
    
}
