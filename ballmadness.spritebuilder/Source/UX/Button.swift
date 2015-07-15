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
        
        // Block Touch while validating
        ignoreTouch = true
        
        // Action to Perform
        switch action {
            case "play":
                delegate?.playButton?()
            case "retry":
                delegate?.retryButton?()
        default:
            println("No Action")
            ignoreTouch = false // Resume Touch
        }
    }
}

// MARK:- Delegate
@objc protocol ButtonDelegate {
    optional func playButton()
    optional func retryButton()
}
