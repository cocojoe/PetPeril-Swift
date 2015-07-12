import Foundation

class PlatformControl : Platform {
    
    // Range
    var minVertical: CGFloat = 0
    var maxVertical: CGFloat = 0
    var direction  : CGFloat = 0
    
    //
    let verticalClamp: CGPoint = ccp(12.0,12.0)
    
    // Touch Enabled
    var enableControl = false
    
    // MARK - Creation
    
    func setup() {
        // Enable Control
        enableControl = true
    }
    
    // MARK - Game Logic
    
    func processMove(positionChange: CGPoint) {
        
        // Ensure Controlled
        if enableControl == false {
            return
        }
        
        let positionDiff = ccpClamp(positionChange, ccpMult(verticalClamp,-1), verticalClamp)
        position = ccpAdd(position,ccp(0,positionDiff.y*direction))
        
        // Check Vertical Constraints
        if position.y < minVertical {
            position.y = minVertical
        } else if position.y > maxVertical {
            position.y = maxVertical
        }

    }
    
    
}
