import Foundation

class PlatformControl : Platform {
    
    // Range
    var minVertical: CGFloat = 0
    var maxVertical: CGFloat = 0
    var direction  : CGFloat = 0
    var initialPosition: CGPoint = CGPointZero
    
    // Movement Clamping
    let verticalClamp: CGPoint = ccp(0,12.0)
    var currentDirection: Int = 0
    var lastDirection: Int = 0
    
    // Touch Enabled
    var enableControl = false
    
    // MARK - Creation
    
    func setup() {
        
        // Enable Control
        enableControl = true
        
        // Tweak Physics
        pillar.physicsBody.type = .Dynamic
        pillar.physicsBody.mass = 25
        
        // Store Position
        initialPosition = pillar.position
    }
    
    // MARK:- Game Logic
    
    override func update(delta: CCTime) {
        
        // Ensure Controlled
        if enableControl == false { return }
        
        // Clamp Horizontal Velocity
        pillar.physicsBody.velocity.x = 0
        
        /*
        println("Pos: \(pillar.position)")
        println("Min: \(minVertical)")
        println("Max: \(maxVertical)")
        */

        // Check Vertical Constraints
        if pillar.position.y <= minVertical {
            deadStop()
            pillar.position.y = minVertical
        } else if pillar.position.y >= maxVertical {
            deadStop()
            pillar.position.y = maxVertical
        }

    }
    
    // MARK:- Movement
    
    func processMove(positionChange: CGPoint) {
        
        // Ensure Controlled
        if enableControl == false { return }
        
        let positionDiff = ccpClamp(positionChange, ccpMult(verticalClamp,-1), verticalClamp)
        currentDirection = positionDiff.y.signum
        
        // Quick Stop When Direction Change
        if lastDirection != currentDirection { deadStop() }
        
        // Apply Impulse
        pillar.physicsBody.applyImpulse(ccpMult(ccp(0,positionDiff.y*direction),150))
        
        // Set Last Direction
        lastDirection = currentDirection
        
    }
    
    func deadStop() {
        pillar.physicsBody.velocity = CGPointZero
    }
    
    
}
