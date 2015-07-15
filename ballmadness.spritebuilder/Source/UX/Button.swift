import Foundation

class Button : CCSprite {
    
    func didLoadFromCCB() {
        
        self.userInteractionEnabled = true

        let throbSequence:CCActionSequence = CCActionSequence(array:
            [CCActionScaleTo(duration: 1.0, scale: 1.10),
            CCActionScaleTo(duration: 1.0, scale: 1.00)])
        
        // Throb
        runAction(CCActionRepeatForever(action: throbSequence))
    }
    
    // MARK: - Touch Handlers
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        playButton()
    }
    
    // MARK: - Actions
    
    func playButton() {
        var gameScene: CCScene = CCBReader.loadAsScene("GameScene")
        CCDirector.sharedDirector().replaceScene(gameScene);
    }
}
