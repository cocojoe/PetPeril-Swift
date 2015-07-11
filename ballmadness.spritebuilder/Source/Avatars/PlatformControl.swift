import Foundation

class PlatformControl : Platform {
    
    // Range
    var minVertical: CGFloat = 0
    var maxVertical: CGFloat = 0
    var direction  : CGFloat = 0
    
    // Touch Enabled
    var enableControl = false
    
    // MARK - Creation
    
    func setup() {
        // Enable Control
        enableControl = true
    }
    
    // MARK - Game Logic
    
    func validateConstraints() {
        
        // Check Vertical Constraints
        if position.y < minVertical {
            position.y = minVertical
        } else if position.y > maxVertical {
            position.y = maxVertical
        }
    }
    
    
}
