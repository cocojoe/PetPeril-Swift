import Foundation

class Character : CCNode {
    
    var body: CCSprite!
    var acceleration: CGPoint = ccp(2.0,0.0)
    var maxVelocity: CGPoint  = ccp(20.0,50.0)
    let equateStamp: Double = CACurrentMediaTime()
    var active = false
    
    func didLoadFromCCB() {
    }
    
    override func update(delta: CCTime) {
       
        // Only Process Active Characters
        if active==false {
            return
        }
        
        body.physicsBody.applyImpulse(acceleration)
        
        
        // X Limiter
        if body.physicsBody.velocity.x > maxVelocity.x {
            body.physicsBody.velocity.x = maxVelocity.x
        }
        
    }
    
    func disablePhysics() {
        active = false
        
        // Ignore Collisions
        body.physicsBody.type = .Static
        body.physicsBody.sensor = true
    }
    
}

// MARK:- Equatable

extension Character: Equatable {}

func ==(lhs: Character, rhs: Character) -> Bool {
    return lhs.equateStamp == rhs.equateStamp
}