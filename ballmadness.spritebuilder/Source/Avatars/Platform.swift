import Foundation

class Platform : CCNode {
    
    var pillar: CCSprite!
    
    var minVertical: CGFloat = 0
    var maxVertical: CGFloat = 0
    
    let scaleRandomiser : [CGFloat] = [1.25,1.5,1.75,2.0]
    let offsetRandomiser: [CGFloat] = [25,-25,50,-50]
    
    let minRandomiser: [CGFloat] = [25,40,55]
    let maxRandomiser: [CGFloat] = [25,40,55]
    
    func didLoadFromCCB() {
    }
    
    // MARK - Creation
    
    func randomize() {
        pillar.flipX = Bool(Int.random(2))
        
        // Create Physics Body
        pillar.physicsBody = CCPhysicsBody(rect:pillar.boundingBox(), cornerRadius: 0)
        pillar.physicsBody.type = .Static
    }
    
    func addConstraints() {
        
        // Set Vertical Constraints
        minVertical = position.y - minRandomiser.randomItem()
        maxVertical = position.y + maxRandomiser.randomItem()
    
    }
    
    // MARK - Game Logic
    
    func checkConstraints() {
        
        // Check Vertical Constraints
        if position.y < minVertical {
            position.y = minVertical
        } else if position.y > maxVertical {
            position.y = maxVertical
        }
        
        // World Constraints
        if position.y > 0.0 {
            position.y = 0.0
        }
    }
    
    
}
