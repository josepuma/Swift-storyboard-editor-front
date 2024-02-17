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
    private var timeLinePosition : Double = 0
    //Commands
    private var moveXCommands : [Command] = []
    private var moveYCommands : [Command] = []
    private var fadeCommands : [Command] = []
    private var scaleCommands : [Command] = []
    private var rotateCommands : [Command] = []
    
    private var startTimes : [Double] = []
    private var endTimes : [Double] = []
    
    var isActive : Bool {
        let start = startTimes.min()
        let end = endTimes.max()
        if(start != nil && end != nil){
            if timeLinePosition >= start! && end! >= timeLinePosition{
                return true
            }
        }
        return false
    }
    
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
        startTimes.append(startTime)
        endTimes.append(endTime)
        moveXCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue))
    }
    
    func moveY(startTime: Double, endTime: Double, startValue: Double, endValue: Double){
        startTimes.append(startTime)
        endTimes.append(endTime)
        moveYCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue))
    }
    
    func fade(startTime: Double, endTime: Double, startValue: Double, endValue: Double){
        startTimes.append(startTime)
        endTimes.append(endTime)
        fadeCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue))
    }
    
    func scale(startTime: Double, endTime: Double, startValue: Double, endValue: Double){
        startTimes.append(startTime)
        endTimes.append(endTime)
        scaleCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue))
    }
    
    func rotate(startTime: Double, endTime: Double, startValue: Double, endValue: Double){
        startTimes.append(startTime)
        endTimes.append(endTime)
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
        timeLinePosition = timePosition
        if isActive {
            self.isHidden = false
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
                    self.xScale = command.value
                    self.yScale = command.value
                }
            }
            for command in rotateCommands {
                command.setTimePosition(position: timePosition)
                if command.isActive{
                    self.position.x = command.value
                }
            }
        }else{
            self.isHidden = true
        }
        //self.isHidden = false
    }
    
    
}
