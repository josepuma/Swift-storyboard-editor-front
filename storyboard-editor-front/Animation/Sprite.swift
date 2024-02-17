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
    
    //Commands
    private var moveXCommands : [Command] = []
    private var moveYCommands : [Command] = []
    private var fadeCommands : [Command] = []
    private var scaleCommands : [Command] = []
    private var rotateCommands : [Command] = []
    
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
    
    func moveX(startTime: Double, endTime: Double, startValue: Double, endValue: Double){
        moveXCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue))
    }
    
    func moveY(startTime: Double, endTime: Double, startValue: Double, endValue: Double){
        moveYCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue))
    }
    
    func fade(startTime: Double, endTime: Double, startValue: Double, endValue: Double){
        fadeCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue))
    }
    
    func scale(startTime: Double, endTime: Double, startValue: Double, endValue: Double){
        scaleCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue))
    }
    
    func rotate(startTime: Double, endTime: Double, startValue: Double, endValue: Double){
        rotateCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue))
    }
    
    func loadTexture(texture: SKTexture){
        self.texture = texture
        self.position = CGPoint(x: 420 , y: 240)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.color = .blue
        self.size = CGSize(width: texture.size().width, height: texture.size().height)
    }
    
    func update(timePosition: Double){
        for command in moveXCommands {
            command.setTimePosition(position: timePosition)
            if command.isActive{
                self.position.x = command.value
            }
        }
        for command in moveYCommands {
            command.setTimePosition(position: timePosition)
            if command.isActive{
                self.position.y = command.value
            }
        }
        for command in fadeCommands {
            command.setTimePosition(position: timePosition)
            if command.isActive{
                self.alpha = command.value
            }
        }
        for command in scaleCommands {
            command.setTimePosition(position: timePosition)
            if command.isActive{
                self.size.width = self.size.width * command.value
                self.size.height = self.size.height * command.value
            }
        }
        for command in rotateCommands {
            command.setTimePosition(position: timePosition)
            if command.isActive{
                self.position.x = command.value
            }
        }
    }
    
}
