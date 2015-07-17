import Foundation

/*
 * Button Background Colour: 719d24
 */

class MainScene: CCNode, CCPhysicsCollisionDelegate {
    
    weak var physicsWorld: CCPhysicsNode!
    
    func didLoadFromCCB() {
        
        // Any Buttons Require Delegate Setting to Self
        registerButtonDelegates(self)
        
        // Physics Delegate
        physicsWorld.collisionDelegate = self
        physicsWorld.debugDraw = false
    }
    
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, character characterBody: CCNode!, characterBounce: Bounce!) -> Bool {
        
        // Character
        var character: Character = characterBody.parent as! Character
        character.reverse()
        
        return true
    }

}

// MARK:- UX Delegate
extension MainScene: ButtonDelegate {
    
    func playButton() {
        var gameScene: CCScene = CCBReader.loadAsScene("GameScene")
        CCDirector.sharedDirector().replaceScene(gameScene);
    }
    
}