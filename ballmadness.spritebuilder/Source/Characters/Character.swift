import Foundation

class Character : CCNode {
    
    var body: CCSprite!
    var acceleration: CGPoint = ccp(2.0,0.0)
    var maxVelocity: CGPoint  = ccp(20.0,50.0)
    let equateStamp: Double = CACurrentMediaTime()
    
    func didLoadFromCCB() {
    }
    
    override func update(delta: CCTime) {
        
        body.physicsBody.applyImpulse(acceleration)
        
        // X Limiter
        if body.physicsBody.velocity.x > maxVelocity.x {
            body.physicsBody.velocity.x = maxVelocity.x
        }
        
        // Y Limiter
        if body.physicsBody.velocity.y > maxVelocity.y {
            body.physicsBody.applyImpulse(ccp(0,-40.0))
        }
    }
    
}

// MARK:- Equatable

extension Character: Equatable {}

func ==(lhs: Character, rhs: Character) -> Bool {
    return lhs.equateStamp == rhs.equateStamp
}