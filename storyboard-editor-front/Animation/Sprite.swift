//
//  Sprite.swift
//  storyboard-editor-front
//
//  Created by José Puma on 16-02-24.
//
import SpriteKit
class Sprite : SKSpriteNode {
    private var sprite = SKSpriteNode()
    var spritePath : String = ""
    
    convenience init(spritePath: String) {
        self.init(imageNamed: spritePath)
        self.spritePath = spritePath
    }
    
    override init(texture: SKTexture!, color: NSColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveX(){
        
    }
    
    func loadTexture(texture: SKTexture){
        self.texture = texture
        self.position = CGPoint(x: 420 , y: 240)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.color = .blue
        self.size = CGSize(width: texture.size().width, height: texture.size().height)
    }
    
}
