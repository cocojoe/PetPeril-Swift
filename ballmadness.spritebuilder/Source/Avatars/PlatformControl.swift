import Foundation

class PlatformControl : Platform {
    
    // Range
    var minVertical: CGFloat = 0
    var maxVertical: CGFloat = 0
    
    var enableControl = false
    
    // MARK - Creation
    
    func setup() {
        
        // Enable Control
        enableControl = true
    }
    
    // MARK - Game Logic
    
    func checkConstraints() {
        
        // Check Vertical Constraints
        if position.y < minVertical {
            position.y = minVertical
        } else if position.y > maxVertical {
            position.y = maxVertical
        }
    }
    
    
}
