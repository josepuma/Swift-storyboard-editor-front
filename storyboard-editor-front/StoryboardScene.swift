//
//  StoryboardScene.swift
//  storyboard-editor-front
//
//  Created by José Puma on 17-02-24.
//

import Foundation
import SpriteKit
import Combine
import JavaScriptCore
import SFSMonitor


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
    
    
    var storyboard = Storyboard()
    let utilities = Utilities()
    let serialSpritesQueue = DispatchQueue(label: "sprites.adding.queue")
    let dispatchGroup = DispatchGroup()
    var scripts : [ScriptFile] = []
    private var queue : SFSMonitor?
    
    var spritesToUpdate : [Sprite] {
        return renderSprites.sorted { sprite1, sprite2 in
            return sprite1.script!.order < sprite2.script!.order
        }
    }
    
    override init(){
        super.init(size: CGSize(width: 854, height: 480))
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
    
    func loadTexturesSprites(textures: [String: SKTexture], sprites: [Sprite]){
        Store.textures = textures
        renderSprites.removeAll()
        removeAllChildren()
        for sprite in sprites{
            if(sprite.isTextSprite){
                let newTexture = utilities.generateTextureFromSprite(from: sprite)
                sprite.loadTexture(texture: newTexture)
                self.addChild(sprite)
                self.renderSprites.append(sprite)
            }else{
                self.addChild(sprite)
                self.renderSprites.append(sprite)
               /* let texture = Store.textures[sprite.spritePath]
                if texture != nil {
                    //sprite.loadTexture(texture: texture!)
                    
                }*/
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
        
    }
    
    override func keyDown(with event: NSEvent) {
        let keyCode: UInt16 = event.keyCode
        //let l : UInt16 = 0x7B
        //let r : UInt16 = 0x7C
        switch(keyCode){
            case 49: //spacebar
                player.play()
            case 53:
                self.view?.window?.collectionBehavior = .fullScreenNone
                self.view?.exitFullScreenMode()
            case 123:
                let currentPosition = player.getPosition()
                player.setPosition(position: Int(currentPosition - 2000))
            case 124:
                let currentPosition = player.getPosition()
                player.setPosition(position: Int(currentPosition + 2000))
        default:
            print("")
        }
    }
    
    override func sceneDidLoad() {
        scene?.backgroundColor = .clear
        player = Player()
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
        
        
        let positionTimeLine = player.getPosition()
        musicPosition = player.getPositionFormatted()
        finalMusicPosition = self.musicPosition
        musicPositionTime = positionTimeLine
        finalMusicPositionTime = positionTimeLine
        
        for sprite in spritesToUpdate {
            sprite.update(timePosition: positionTimeLine)
        }
    }
    
    var previousNode = Sprite()
    var previousknode = SKShapeNode()
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let nodeInPosition = self.atPoint(location)
        print(nodeInPosition)
        if let shapeNode = nodeInPosition as? SKShapeNode{
            removeChildren(in: [shapeNode])
        }
        if let currentNode = nodeInPosition as? Sprite{
            let newsknode = currentNode.drawBorder()
            
            if newsknode == previousknode{
                //print("entered here?")
                return
            }
            
            
            if previousNode.spritePath.isEmpty{
                addChild(newsknode)
                previousNode = currentNode
                previousknode = newsknode
                //print("added border")
            }else{
                removeChildren(in: [previousknode])
                addChild(newsknode)
                previousNode = currentNode
                previousknode = newsknode
                //print("removed border")
            }
        }
        
        
    }
    
    
    func loadSprites(_ sprites: [Sprite], script: ScriptFile){
        let spritesToRemove = renderSprites.filter { $0.script == script }
        renderSprites.removeAll{ $0.script == script}
        removeChildren(in: spritesToRemove)

        for sprite in sprites{
            if(sprite.isTextSprite){
                /*let texture = Store.textures[sprite.spritePath]
                if texture != nil{
                    sprite.loadTexture(texture: texture!)
                }else{
                    let newTexture = utilities.generateTextureFromSprite(from: sprite)
                    //Store.textures[sprite.spritePath] = newTexture
                    sprite.loadTexture(texture: newTexture)
                }*/
                let newTexture = utilities.generateTextureFromSprite(from: sprite)
                sprite.loadTexture(texture: newTexture)
                self.addChild(sprite)
                self.renderSprites.append(sprite)
            }else{
                self.addChild(sprite)
                self.renderSprites.append(sprite)
                /*let texture = Store.textures[sprite.spritePath]
                if texture != nil {
                    sprite.loadTexture(texture: texture!)
                    
                }*/
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
    
    func generateOsbCode(){
        var osb = "[Events]\n//Background and Video events\n//Storyboard Layer 0 (Background)\n"
        osb.append("//Storyboard Layer 1 (Fail)\n//Storyboard Layer 2 (Pass)\n//Storyboard Layer 3 (Foreground)\n")
        for sprite in spritesToUpdate{
            osb.append(sprite.toOsb())
        }
        osb.append("//Storyboard Layer 4 (Overlay)\n//Storyboard Sound Samples\n")
        
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(osb, forType: .string)
        
        print(osb)
        
    }
    
    
}
