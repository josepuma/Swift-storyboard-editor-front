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
    private var scaleXCommands : [Command] = []
    private var scaleYCommands : [Command] = []
    private var fadeCommands : [Command] = []
    private var rotateCommands : [Command] = []
    private var scaleCommands : [Command] = []
    private var moveCommands : [VectorCommand] = []
    private var areCommandsCalculated :  Bool = false;
    private var startTimes : [Double] = []
    private var endTimes : [Double] = []
    private var start : Double = 0
    private var end : Double = 0
    
    var isLoaded : Bool = false
    
    var isActive : Bool {
        if start <= timeLinePosition && timeLinePosition <= end{
            return true
        }
        return false
    }
    
    convenience init(spritePath: String) {
        self.init(imageNamed: spritePath)
        self.spritePath = spritePath
        self.position = CGPoint(x: 427 , y: -240)
    }
    
    convenience init(spritePath: String, position: CGPoint) {
        self.init(imageNamed: spritePath)
        self.spritePath = spritePath
        self.position.x = position.x + 107
        self.position.y = position.y * -1
    }
    
    override init(texture: SKTexture!, color: NSColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(startTime: Double, endTime: Double, startValue: CGPoint, endValue: CGPoint){
        startTimes.append(startTime)
        endTimes.append(endTime)
        moveCommands.append(VectorCommand(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue))
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
    
    func scaleX(startTime: Double, endTime: Double, startValue: Double, endValue: Double){
        startTimes.append(startTime)
        endTimes.append(endTime)
        scaleXCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue))
    }
    
    func scaleY(startTime: Double, endTime: Double, startValue: Double, endValue: Double){
        startTimes.append(startTime)
        endTimes.append(endTime)
        scaleYCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue))
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
    
    func color(r: Double, g: Double, b: Double){
        let spriteColor = NSColor(red: r, green: g, blue: b, alpha: 1)
        self.color = spriteColor
        self.colorBlendFactor = 1
    }
    
    func loadTexture(texture: SKTexture){
        self.texture = texture
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.size = CGSize(width: texture.size().width, height: texture.size().height)
    }
    
    func isActiveAtTime(position: Double) -> Bool{
        return start <= timeLinePosition && timeLinePosition <= end
    }
    
    func valueAt(position: Double, commands: [Command], defaultValue: Double = 1) -> Double{
        var index = 0
        if(commands.count == 0){
            return defaultValue
        }
        
        let foundCommand = findCommandIndex(position: position, commands: commands)
        index = foundCommand.1
        
        if !findCommandIndex(position: position, commands: commands).0 && index > 0{
            index = index - 1
        }
        
        let command = commands[index]
        return command.valueAt(position: position)
    }
    
    func findCommandIndex(position: Double, commands: [Command]) -> (Bool, Int) {
        var left = 0
        var right = commands.count - 1
        var index = 0
        while left <= right {
            index = left + (( right - left ) >> 1)
            let commandTime = commands[index].startTime
            if commandTime == position{
                return (true, index)
            }
            else if commandTime < position {
                left = index + 1
            }else{
                right = index - 1
            }
        }
        index = left
        return (false, index)
    }
    
    func valueAtVector(position: Double, commands: [VectorCommand], defaultVale : CGPoint = CGPoint(x: 1, y: 1)) -> CGPoint{
        var index = 0
        if(commands.count == 0){
            return defaultVale
        }
        for (i, command) in commands.enumerated() {
            if(position < command.endTime){
                index = i
                break
            }
        }
        let command = commands[index]
        return command.valueAt(position: position)
    }
    
    func update(timePosition: Double){
        timeLinePosition = timePosition
        if(areCommandsCalculated){
            if isActive {
                self.isHidden = false
                let opacity = valueAt(position: timePosition, commands: fadeCommands)
                if(opacity < 0.00001){
                    return
                }
                self.alpha = opacity
                
                if(scaleCommands.count > 0){
                    let scale = valueAt(position: timePosition, commands: scaleCommands)
                    self.xScale = scale
                    self.yScale = scale
                }else{
                    self.yScale = valueAt(position: timePosition, commands: scaleYCommands)
                    self.xScale = valueAt(position: timePosition, commands: scaleXCommands)
                }
                
                
                if(moveCommands.count > 0){
                    let positionFinal = valueAtVector(position: timePosition, commands: moveCommands, defaultVale: CGPoint(x: 427 , y: -240))
                    self.position.x = positionFinal.x
                    self.position.y = positionFinal.y * -1
                }else{
                    //self.position.x = valueAt(position: timePosition, commands: moveXCommands)
                    //self.position.y = valueAt(position: timePosition, commands: moveYCommands) * -1
                }
                let rotation = valueAt(position: timePosition, commands: rotateCommands, defaultValue: 0)
                self.zRotation = rotation > 0 ? .pi / rotation : rotation
            }else{
                self.isHidden = true
                return
            }
        }else{
            setInitialValues()
        }
    }
    
    func setInitialValues(){
        start = startTimes.min()!
        end = endTimes.max()!
        if(fadeCommands.count > 0){
            self.alpha = fadeCommands[0].startValue;
        }
        if(scaleCommands.count > 0){
            self.xScale = scaleCommands[0].value
            self.yScale = scaleCommands[0].value
        }
        if(moveXCommands.count > 0){
            self.position.x = moveXCommands[0].value
        }
        if(moveYCommands.count > 0){
            self.position.y = moveYCommands[0].value * -1
        }
        if(scaleXCommands.count > 0){
            self.xScale = scaleXCommands[0].value
        }
        if(scaleYCommands.count > 0){
            self.yScale = scaleYCommands[0].value
        }
        areCommandsCalculated = true
    }
    
    
}

extension SKSpriteNode {

    func addGlow(radius: Float = 30) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        addChild(effectNode)
        let effect = SKSpriteNode(texture: texture)
        effect.color = self.color
        effect.colorBlendFactor = 1
        effectNode.addChild(effect)
        effectNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius":radius])
    }
}
