import Foundation

class Button : CCSprite {
    
    var ignoreTouch:Bool = false
    var attract:Bool = false
    var action:String = ""
    
    weak var delegate : ButtonDelegate?
    
    func didLoadFromCCB() {
        
        self.userInteractionEnabled = true
        
        // Attract Mode
        if attract == true {
            let throbSequence:CCActionSequence = CCActionSequence(array:
                [CCActionScaleTo(duration: 1.0, scale: 1.10),
                    CCActionScaleTo(duration: 1.0, scale: 1.00)])
            
            // Throb
            runAction(CCActionRepeatForever(action: throbSequence))
        }
    }
    
    // MARK: - Touch Handlers
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
       
        // Ensure No Duplicates
        if ignoreTouch == true { return }
        
        // Block Subsequent Touches
        ignoreTouch = true
        
        // Action to Perform
        switch action {
            case "play":
                delegate?.playButton?()
            case "retry":
                delegate?.retryButton?()
            case "exit":
                delegate?.exitButton?()
            case "pause":
                delegate?.pauseButton?()
                ignoreTouch = false     // Non Locking Button
        default:
            println("Non Supported Action: \(action)")
            return
        }
        
        // Animate Button Pop
        if attract == false {
            let popSequence:CCActionSequence = CCActionSequence(array:
                [CCActionScaleTo(duration: 0.10, scale: self.scale * 1.10),
                    CCActionScaleTo(duration: 0.10, scale: self.scale)])
            
            // Pop
            runAction(popSequence)
        }
    }
}

// MARK:- Delegate
@objc protocol ButtonDelegate {
    optional func playButton()
    optional func retryButton()
    optional func exitButton()
    optional func pauseButton()
}
