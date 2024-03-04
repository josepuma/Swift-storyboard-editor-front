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
import SwiftyLua

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
    let serialSpritesQueue = DispatchQueue(label: "sprites.adding.queue")
    let dispatchGroup = DispatchGroup()
    
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
    
    override func didMove(to view: SKView) {
        textures = loadTextures(path: "/Users/josepuma/Downloads/470977 Mili - world.execute(me);/SB")
        //let image = NSImage(size: CGSize(width: 14, height: 82)).addTextToImage(drawText: "e")
        //let spriteTexture = SKTexture(cgImage: image)
        //textures["hola.png"] = spriteTexture
        //loadStoryboard()
        storyboard.loadTextures(textures: textures)
        reloadStoryboardScene()
    }
    
    override func sceneDidLoad() {
        scene?.backgroundColor = .clear
        player = Player(soundPath: "/Users/josepuma/Downloads/470977 Mili - world.execute(me);/audio.mp3")
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
        for sprite in self.renderSprites {
            sprite.update(timePosition: positionTimeLine)
        }
    }
    
    func loadStoryboardScript(completion: @escaping(_ spriteArray: [Sprite]) -> Void ){
        let path = "/Users/josepuma/Downloads/35701 Lia - Toki wo Kizamu Uta 2/script.js"
        let context = JSContext()
        context?.setObject(Sprite.self, forKeyedSubscript: NSString(string: "Sprite"))
        context?.setObject(Helpers.self, forKeyedSubscript: NSString(string: "Helpers"))
        let sprites : [Sprite] = []
            do{
                let contents = try String(contentsOfFile: path)
                context!.evaluateScript(contents)
                let generateFunction = context?.objectForKeyedSubscript("generate")
                let response = generateFunction?.call(withArguments: [sprites]).toArray() as? [Sprite]
                completion(response ?? [])
            }catch{
                print(error)
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
    
    func loadOsbStoryboard(completion: @escaping(_ spriteArray: [Sprite]) -> Void ) {
        DispatchQueue.global().async {
            let osbReader = OsbReader(osbPath: "/Users/josepuma/Downloads/470977 Mili - world.execute(me);/Mili - world.execute(me); (Exile-).osb")
            DispatchQueue.main.async {
                completion(osbReader.spriteList)
            }
        }
    }
    
    func reloadStoryboardScene(){
        var sprites : [Sprite] = []
        
        loadOsbStoryboard(){ spritesArray in
            sprites.append(contentsOf: spritesArray)
            print("loaded osb sprites \(spritesArray.count)")
            
            self.loadStoryboardScript(){ spritesArray in
                sprites.append(contentsOf: spritesArray)
                print("loaded script sprites \(spritesArray.count)")
                
                self.storyboard.clearSprites()
                self.storyboard.addSprites(sprites: sprites)
                self.removeAllChildren()
                self.renderSprites.removeAll()
                for sprite in self.storyboard.getSprites(){
                    self.addChild(sprite)
                    //self.addChild(sprite.drawBorder())
                    self.renderSprites.append(sprite)
                }
                print("sprites finished loading")
                
            }
            
            
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

extension NSImage {
    
    var pngData: Data? {
            guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
            return bitmapImage.representation(using: .png, properties: [:])
        }

    func addTextToImage(drawText text: String) -> CGImage {
        let textColor = NSColor.white
        let textFont = NSFont(name: "Arial", size: 36)! //Helvetica Bold
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.backgroundColor: NSColor.red,
            ] as [NSAttributedString.Key : Any]
        
        let size = (text as NSString).size(withAttributes: textFontAttributes)
        self.size = size
        let targetImage = NSImage(size: self.size, flipped: false) { (dstRect: CGRect) -> Bool in
            
            /*let textColor = NSColor.white
            let textFont = NSFont(name: "Arial", size: 36)! //Helvetica Bold
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.center

            let textFontAttributes = [
                NSAttributedString.Key.font: textFont,
                NSAttributedString.Key.foregroundColor: textColor,
                ] as [NSAttributedString.Key : Any]*/

            let textOrigin = CGPoint(x: self.size.width / 2, y: -self.size.height/2)
            let rect = CGRect(origin: textOrigin, size: self.size)
            text.draw(in: rect, withAttributes: textFontAttributes)
            return true
        }
        let route = URL.documentsDirectory.appendingPathComponent("j.png")
        let save = targetImage.pngWrite(to: route)
        if save {
            print("saved")
        }
        return targetImage.cgImage(forProposedRect: nil, context: nil, hints: nil)!
    }
    
    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
            do {
                try pngData?.write(to: url, options: options)
                return true
            } catch {
                print(error)
                return false
            }
        }
}


