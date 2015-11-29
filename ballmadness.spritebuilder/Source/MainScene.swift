import Foundation

/*
 * Button Background Colour: 719d24
 */

class MainScene: CCNode, CCPhysicsCollisionDelegate {
    
    weak var physicsWorld: CCPhysicsNode!
    weak var worldNode: WorldNode!
    weak var worldNode1: WorldNode!
    weak var worldNode2: WorldNode!
    weak var worldNode3: WorldNode!
    
    func didLoadFromCCB() {
        
        // Any Buttons Require Delegate Setting to Self
        registerButtonDelegates(self)
        
        // Physics Delegate
        physicsWorld.collisionDelegate = self
        physicsWorld.debugDraw = false
    }
    
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, character characterBody: CCNode!, characterBounce: Bounce!) -> Bool {
        
        // Character
        let character: Character = characterBody.parent as! Character
        character.reverse()
        
        return true
    }

}

// MARK:- UX Delegate
extension MainScene {
    
    func playButton() {
        let gameScene: CCScene = CCBReader.loadAsScene("GameScene")
        CCDirector.sharedDirector().replaceScene(gameScene);
    }
    
}