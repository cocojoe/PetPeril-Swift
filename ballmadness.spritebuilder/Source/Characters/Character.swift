import Foundation

class Character : CCNode {
    
    var body: CCSprite!
    var acceleration: CGPoint = ccp(4.0,0.0)
    var maxVelocity: CGPoint  = ccp(25.0,35.0)
    let equateStamp: Double = CACurrentMediaTime()
    
    func didLoadFromCCB() {
        body.physicsBody.mass = 0.1
    }
    
    override func update(delta: CCTime) {
        
        if body.physicsBody.velocity.y >= -0.5 {
            body.physicsBody.applyImpulse(acceleration)
        }
        
        // X Limiter
        if body.physicsBody.velocity.x > maxVelocity.x {
            body.physicsBody.velocity.x = maxVelocity.x
        }
        
        // Y Reducer
        if body.physicsBody.velocity.y > maxVelocity.y {
            body.physicsBody.velocity.y = body.physicsBody.velocity.y*0.80
        }
        
    }
    
    func disablePhysics() {

        // Ignore Collisions
        body.physicsBody.type = .Static
        body.physicsBody.sensor = true
        body.physicsBody.collisionMask = []
    }
    
}

// MARK:- Equatable

extension Character: Equatable {}

func ==(lhs: Character, rhs: Character) -> Bool {
    return lhs.equateStamp == rhs.equateStamp
}