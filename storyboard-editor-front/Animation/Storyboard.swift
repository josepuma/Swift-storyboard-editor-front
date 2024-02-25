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
    
    func addSprites(sprites: [Sprite]){
        for sprite in sprites {
            let texture = self.textures[sprite.spritePath]
            if texture != nil {
                sprite.loadTexture(texture: texture!)
                self.sprites.append(sprite)
            }
        }
    }
    
    func clearSprites(){
        sprites.removeAll()
    }
    
    func addSprite(sprite: Sprite){
        let texture = self.textures[sprite.spritePath]
        if texture != nil {
            sprite.loadTexture(texture: texture!)
            sprites.append(sprite)
        }
    }
    
    func getSprites() -> [Sprite]{
        return self.sprites
    }
    
}
