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
    public var textures : [String: SKTexture] = [:]
    
    var storyboard = Storyboard()
    let serialSpritesQueue = DispatchQueue(label: "sprites.adding.queue")
    let dispatchGroup = DispatchGroup()
    public var scriptsReader : CodeFileReader?
    var scripts : [ScriptFile] = []
    let scriptFolderPath = "/Users/josepuma/Documents/sb scripts"
    private var queue : SFSMonitor?
    
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
        textures = loadTextureAssets(url: URL(filePath: "/Users/josepuma/Downloads/547714 RADWIMPS - Hikari"))
        storyboard.loadTextures(textures: textures)
        scriptsReader = CodeFileReader(scriptFolderPath)
        reloadStoryboardScene()
        
        let project = Project(name: "Naturaleza Inspiradora Proyectos Brillantes", backgroundMusicPath: "audio.mp3", bpm: 190.5, offset: 120)
        let projectHandler = ProjectHandler(project)
        projectHandler.saveProjectSettings()
        
        
    }
    
    override func keyDown(with event: NSEvent) {
        let keyCode: UInt16 = event.keyCode
        let l : UInt16 = 0x7B
        let r : UInt16 = 0x7C
        print(l, r)
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
        player = Player(soundPath: "/Users/josepuma/Downloads/547714 RADWIMPS - Hikari/audio.mp3")
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
            let osbReader = OsbReader(osbPath: "/Users/josepuma/Downloads/547714 RADWIMPS - Hikari/RADWIMPS - Hikari (Haruto).osb")
            DispatchQueue.main.async {
                print("sprites", osbReader.spriteList.count)
                completion(osbReader.spriteList)
            }
        }
    }
    
    
    func reloadStoryboardScene(){
        var sprites : [Sprite] = []
        
        loadOsbStoryboard(){ spritesArray in
            sprites.append(contentsOf: spritesArray)
            print("loaded osb sprites \(spritesArray.count)")
            self.scriptsReader?.loadScripts(){ scriptSpritesArray in
                sprites.append(contentsOf: scriptSpritesArray.sprites)
                self.scripts = scriptSpritesArray.scripts
                print("loaded script sprites \(scriptSpritesArray.sprites.count)")
                
                for file in scriptSpritesArray.scripts{
                    print(file.path)
                    _ = self.queue?.addURL(URL(filePath: file.path))
                }
                
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
    
    
    func getAudioPosition() -> Double {
        return player.getPosition()
    }
    
    func getAudioLength() -> Double {
        return player.getLength()
    }
    
    func updateAudioPosition(position: Double){
        player.setPosition(position: Int(position))
    }
    
    private func loadTextureAssets(url: URL)  -> [String: SKTexture] {
        var sprites : [String: SKTexture] = [:]
        if let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
            for case let fileURL as URL in enumerator {
                do {
                    let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
                    if fileAttributes.isRegularFile! {
                        if fileURL.pathExtension == "png" || fileURL.pathExtension == "jpeg" || fileURL.pathExtension == "jpg" {
                            let fileName = fileURL.relativeString.replacingOccurrences(of: "\(url.relativeString)/", with: "").removingPercentEncoding
                            let spriteImage = try CGImage.load(fileURL: fileURL)
                            let spriteTexture = SKTexture(cgImage: spriteImage)
                            sprites[fileName!.lowercased()] = spriteTexture
                        }
                    }
                } catch { print(error, fileURL) }
            }
            return sprites
        }
        return sprites
    }
    
}
