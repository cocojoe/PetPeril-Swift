import Foundation

class MainScene: CCNode {
    
    // MARK: - UI Actions
    
    func gameStart() {
        var gameScene: CCScene = CCBReader.loadAsScene("GameScene")
        CCDirector.sharedDirector().replaceScene(gameScene);
    }

}
