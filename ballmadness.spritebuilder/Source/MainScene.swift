import Foundation

/*
 * Button Background Colour: 719d24
 */

class MainScene: CCNode {
    
    func didLoadFromCCB() {
        
        // Any Buttons Require Delegate Setting to Self
        registerButtonDelegates()
    }
    
    func registerButtonDelegates() {
        
        // Any Buttons Require Delegate Setting to Self
        for childNode in self.children as! [CCNode] {
            
            // Enable Control for Tagged Platforms
            if childNode.name == "button" {
                
                var buttonNode = childNode as! Button
                buttonNode.delegate = self
            }
        }
    }
}

// MARK:- UX Delegate
extension MainScene: ButtonDelegate {
    
    func playButton() {
        var gameScene: CCScene = CCBReader.loadAsScene("GameScene")
        CCDirector.sharedDirector().replaceScene(gameScene);
    }
    
}