//
//  Sprite.swift
//  storyboard-editor-front
//
//  Created by José Puma on 16-02-24.
//
import SpriteKit
import JavaScriptCore

@objc protocol SpriteExport: JSExport{
    var spritePath: String{ get set}
    static func createWith(spritePath: String) -> Sprite
    func setOpacity(_ startTime: Double, _ endTime: Double, _ startValue: Double, _ endValue: Double)
    func setOpacity(easing: String, _ startTime: Double, _ endTime: Double, _ startValue: Double, _ endValue: Double)
    
    func setScale(_ startTime: Double, _ endTime: Double, _ startValue: Double, _ endValue: Double)
    func setScale(easing: String, _ startTime: Double, _ endTime: Double, _ startValue: Double, _ endValue: Double)
    
    func setRotation(_ startTime: Double, _ endTime: Double, _ startValue: Double, _ endValue: Double)
    func setRotation(easing: String, _ startTime: Double, _ endTime: Double, _ startValue: Double, _ endValue: Double)
    
    func setMoveX(_ startTime: Double, _ endTime: Double, _ startValue: Double, _ endValue: Double)
    func setMoveX(easing: String, _ startTime: Double, _ endTime: Double, _ startValue: Double, _ endValue: Double)
    
    func setMoveY(_ startTime: Double, _ endTime: Double, _ startValue: Double, _ endValue: Double)
    func setMoveY(easing: String, _ startTime: Double, _ endTime: Double, _ startValue: Double, _ endValue: Double)
    
    func setMove(_ startTime: Double, _ endTime: Double, _ startValueX: Double, _ startValueY: Double, _ endValueX: Double, _ endValueY: Double)
    func setMove(easing: String, _ startTime: Double, _ endTime: Double, _ startValueX: Double, _ startValueY: Double, _ endValueX: Double, _ endValueY: Double)
    
    func setAdditiveBlend()
}

@objc public class Sprite : SKSpriteNode, SpriteExport {
   
    dynamic var spritePath : String = ""
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
    private var spritePosition : CGPoint = CGPoint(x: 854, y: (-240) * 1)
    private var spriteInfoText = SKLabelNode(fontNamed: "Arial")
    var isLoaded : Bool = false
    
    var isActive : Bool {
        if start <= timeLinePosition && timeLinePosition <= end{
            return true
        }
        return false
    }
    
    class func createWith(spritePath: String) -> Sprite {
        return Sprite(spritePath: spritePath)
    }
    
    convenience init(spritePath: String) {
        //print("# init done #")
        self.init(imageNamed: spritePath)
        self.spritePath = spritePath
        self.spritePosition = CGPoint(x: ((320 + 107) * 1) , y: (240 * -1) * 1)
        self.position = spritePosition
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.isHidden = true
    }
    
    convenience init(spritePath: String, position: CGPoint, origin: SpriteOrigin = SpriteOrigin.centre) {
        self.init(imageNamed: spritePath)
        self.spritePath = spritePath
        self.spritePosition = CGPoint(x: ((position.x + 107) * 1) , y: (position.y * -1) * 1)
        self.position = spritePosition
        self.anchorPoint = origin.anchorPoint
        spriteInfoText.fontSize = 10
        spriteInfoText.fontColor = .white
        spriteInfoText.position = self.spritePosition
        spriteInfoText.numberOfLines = 5
        self.isHidden = true
    }
    
    override init(texture: SKTexture!, color: NSColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawInfo() -> SKLabelNode{
        return self.spriteInfoText
    }
    
    func move(startTime: Double, endTime: Double, startValue: CGPoint, endValue: CGPoint, easing: Easing = .linear){
        startTimes.append(startTime)
        endTimes.append(endTime)
        moveCommands.append(VectorCommand(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue))
    }
    
    func moveX(startTime: Double, endTime: Double, startValue: Double, endValue: Double, easing: Easing = .linear){
        startTimes.append(startTime)
        endTimes.append(endTime)
        moveXCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue, easing: easing))
    }
    
    func moveY(startTime: Double, endTime: Double, startValue: Double, endValue: Double, easing: Easing = .linear){
        startTimes.append(startTime)
        endTimes.append(endTime)
        moveYCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue, easing: easing))
    }
    
    func scaleX(startTime: Double, endTime: Double, startValue: Double, endValue: Double, easing: Easing = .linear){
        startTimes.append(startTime)
        endTimes.append(endTime)
        scaleXCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue, easing: easing))
    }
    
    func scaleY(startTime: Double, endTime: Double, startValue: Double, endValue: Double, easing: Easing = .linear){
        startTimes.append(startTime)
        endTimes.append(endTime)
        scaleYCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue, easing: easing))
    }
    
    func fade(startTime: Double, endTime: Double, startValue: Double, endValue: Double, easing: Easing = .linear){
        startTimes.append(startTime)
        endTimes.append(endTime)
        fadeCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue, easing: easing))
    }
    
    func scale(startTime: Double, endTime: Double, startValue: Double, endValue: Double, easing: Easing = .linear){
        startTimes.append(startTime)
        endTimes.append(endTime)
        scaleCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue, easing: easing))
    }
    
    func rotate(startTime: Double, endTime: Double, startValue: Double, endValue: Double, easing: Easing = .linear){
        startTimes.append(startTime)
        endTimes.append(endTime)
        rotateCommands.append(Command(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue, easing: easing))
    }
    
    func color(r: Double, g: Double, b: Double, easing: Easing = .linear){
        let spriteColor = NSColor(red: r, green: g, blue: b, alpha: 1)
        self.color = spriteColor
        self.colorBlendFactor = 1
    }
    
    //JavascriptCore Functions
    
    func setOpacity(_ startTime: Double, _ endTime: Double, _ startValue: Double, _ endValue: Double) {
        fade(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue)
    }
    
    func setOpacity(easing: String, _ startTime: Double, _ endTime: Double, _ startValue: Double, _ endValue: Double) {
        fade(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue, easing: Easing(rawValue: easing)!)
    }
    
    func setScale(_ startTime: Double, _ endTime: Double, _ startValue: Double, _ endValue: Double) {
        scale(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue)
    }
    
    func setScale(easing: String, _ startTime: Double, _ endTime: Double, _ startValue: Double, _ endValue: Double) {
        scale(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue, easing: Easing(rawValue: easing)!)
    }
    
    func setRotation(_ startTime: Double, _ endTime: Double, _ startValue: Double, _ endValue: Double) {
        rotate(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue)
    }
    
    func setRotation(easing: String, _ startTime: Double, _ endTime: Double, _ startValue: Double, _ endValue: Double) {
        rotate(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue, easing: Easing(rawValue: easing)!)
    }
    
    func setMoveX(_ startTime: Double, _ endTime: Double, _ startValue: Double, _ endValue: Double) {
        moveX(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue)
    }
    
    func setMoveX(easing: String, _ startTime: Double, _ endTime: Double, _ startValue: Double, _ endValue: Double) {
        moveX(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue, easing: Easing(rawValue: easing)!)
    }
    
    
    func setMoveY(_ startTime: Double, _ endTime: Double, _ startValue: Double, _ endValue: Double) {
        moveY(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue)
    }
    
    func setMoveY(easing: String, _ startTime: Double, _ endTime: Double, _ startValue: Double, _ endValue: Double) {
        moveY(startTime: startTime, endTime: endTime, startValue: startValue, endValue: endValue, easing: Easing(rawValue: easing)!)
    }
    
    func setMove(_ startTime: Double, _ endTime: Double, _ startValueX: Double, _ startValueY: Double, _ endValueX: Double,  _ endValueY: Double) {
        move(startTime: startTime, endTime: endTime, startValue: CGPoint(x: startValueX, y: startValueY), endValue: CGPoint(x: endValueX, y: endValueY))
    }
    
    func setMove(easing: String,_ startTime: Double, _ endTime: Double, _ startValueX: Double, _ startValueY: Double, _ endValueX: Double,  _ endValueY: Double) {
        move(startTime: startTime, endTime: endTime, startValue: CGPoint(x: startValueX, y: startValueY), endValue: CGPoint(x: endValueX, y: endValueY), easing: Easing(rawValue: easing)!)
    }
    
    func setAdditiveBlend(){
        self.blendMode = .add
    }
    
    //
    
    func loadTexture(texture: SKTexture){
        self.texture = texture
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
    
    func update(timePosition: Double, displaySize: Double = 1){
        timeLinePosition = timePosition
        if(areCommandsCalculated){
            if isActive {
                
                self.isHidden = false
                //spriteInfoText.isHidden = false
                let opacity = valueAt(position: timePosition, commands: fadeCommands)
                if(opacity < 0.00001){
                    //spriteInfoText.isHidden = true
                    self.isHidden = true
                    return
                }
                self.alpha = opacity
                
                if(scaleCommands.count > 0){
                    let scale = valueAt(position: timePosition, commands: scaleCommands)
                    self.xScale = scale * displaySize
                    self.yScale = scale * displaySize
                    if(scale == 0){
                        self.isHidden = true
                        return
                    }
                }else{
                    let scaleX = valueAt(position: timePosition, commands: scaleXCommands)
                    let scaleY = valueAt(position: timePosition, commands: scaleYCommands)
                    self.yScale = scaleY * displaySize
                    self.xScale = scaleX * displaySize
                    if scaleX == 0 || scaleY == 0{
                        self.isHidden = true
                        return
                    }
                }
                
                
                
                /*if(moveCommands.count == 0 && moveXCommands.count == 0 && moveYCommands.count == 0){
                    let positionMove = valueAtVector(position: timePosition, commands: moveCommands, defaultVale: spritePosition)
                    self.position.x = positionMove.x
                    self.position.y = (positionMove.y * -1)
                }*/
                
                if moveCommands.count > 0 {
                    let positionMove = valueAtVector(position: timePosition, commands: moveCommands)
                    self.position.x = positionMove.x * displaySize
                    self.position.y = (positionMove.y * -1) * displaySize
                }
                if moveXCommands.count > 0{
                    self.position.x = valueAt(position: timePosition, commands: moveXCommands, defaultValue: 427) * displaySize
                }
            
                if moveYCommands.count > 0 {
                    self.position.y = (valueAt(position: timePosition, commands: moveYCommands, defaultValue: 240) * -1) * displaySize
                }
                
                
                
                let rotation = valueAt(position: timePosition, commands: rotateCommands, defaultValue: 0)
                self.zRotation = rotation * -1
                
                /*spriteInfoText.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                spriteInfoText.text = self.spritePath + " " + self.anchorPoint.debugDescription + "\n" +
                                      "(x:" + self.position.x.formatted() + " y:" + self.position.y.formatted() + ")\n" +
                                        "scale: (x:" + self.xScale.description +  "y: " + self.yScale.description + ")\n"
                                        + "opacity: " + opacity.description + "\n"
                                        + "rotation: " + rotation.description*/
                
            }else{
                self.isHidden = true
                //spriteInfoText.isHidden = self.isHidden
                return
            }
        }else{
            setInitialValues()
        }
    }
    
    func setInitialValues(){
        start = startTimes.count > 0 ? startTimes.min()! : 0
        end = endTimes.count > 0 ? endTimes.max()! : 0
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
