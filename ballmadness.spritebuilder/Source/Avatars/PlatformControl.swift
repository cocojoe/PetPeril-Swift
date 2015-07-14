import Foundation

class PlatformControl : Platform {
    
    // Range
    var minVertical: CGFloat = 0
    var maxVertical: CGFloat = 0
    var direction  : CGFloat = 0
    var initialPosition: CGPoint = CGPointZero
    
    // Movement Clamping
    let verticalClamp: CGPoint = ccp(0,12.0)
    var positionDiff: CGPoint = CGPointZero
    
    // Touch Enabled
    var enableControl = false
    
    // MARK - Creation
    
    func setup() {
        
        // Enable Control
        enableControl = true
        
        // Tweak Physics
        pillar.physicsBody.type = .Dynamic
        pillar.physicsBody.mass = 50
        
        // Store Position
        initialPosition = pillar.position
    }
    
    // MARK:- Game Logic
    
    override func update(delta: CCTime) {
        
        // Ensure Controlled
        if enableControl == false { return }
        
        // Clamp Horizontal Velocity
        pillar.physicsBody.velocity.x = 0
    }
    
    // MARK:- Movement
    
    func processMove(positionChange: CGPoint) {
        
        // Ensure Controlled
        if enableControl == false { return }
        
        positionDiff = ccpClamp(positionChange, ccpMult(verticalClamp,-1), verticalClamp)
        pillar.physicsBody.applyImpulse(ccpMult(ccp(0,positionDiff.y*direction),100))
        
    }
    
    func deadStop() {
        pillar.physicsBody.velocity = CGPointZero
    }
    
    
}
