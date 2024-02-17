//
//  StoryboardScene.swift
//  storyboard-editor-front
//
//  Created by José Puma on 17-02-24.
//

import Foundation
import SpriteKit
import Combine

class StoryboardScene: SKScene, ObservableObject{
    weak var contentViewModal: ContentViewModel?
    public var player : Player!
    @Published var musicPosition : Double = 20
    public let musicPublisher = CurrentValueSubject<Double, Never>(0)
    private var cancellableSet = Set<AnyCancellable>()
    
    override init(){
        super.init(size: CGSize(width: 854, height: 480))
        musicPublisher
            .sink(receiveValue: { [unowned self] target in
                            self.musicPosition = target
                        })
                        .store(in: &cancellableSet)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
    }
    
    override func sceneDidLoad() {
        scene?.backgroundColor = .clear
        player = Player(soundPath: "/Users/josepuma/Documents/sprites/Niicap - Lifeline.mp3")
    }
    
    @Published var finalMusicPosition : Double = 20 {
        didSet {
            musicPublisher.send(Double(self.musicPosition))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        musicPosition = getAudioPosition()
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
}
