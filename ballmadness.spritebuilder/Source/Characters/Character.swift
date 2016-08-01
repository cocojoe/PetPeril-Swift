import Foundation

class Character : CCNode {
    
    weak var body: CCSprite!
    var acceleration: CGPoint = ccp(5.0,0.0)
    var maxVelocity:  CGPoint = ccp(25.0,35.0)
    let equateStamp:  Double  = CACurrentMediaTime()
    var drown: Bool = false
    var nodesTouching: Int = 0
    
    // Overwrite Speed
    var demoSpeed: CGFloat = 0
    
    func didLoadFromCCB() {
        body.physicsBody.collisionGroup = CCDirector.sharedDirector().physicsGroup
        
        // Presentation Usage
        if demoSpeed > 0 {
            maxVelocity.x = demoSpeed
        }
    }
    
    override func update(delta: CCTime) {
        
        if body.physicsBody == nil { return }
        
        // Demo Mode
        if demoSpeed > 0 { body.physicsBody.applyImpulse(acceleration) }
        
        if body.physicsBody.velocity.y >= -2.0 {
            
            // Resume Walking Animation
            body.animationManager.paused = false
        } else {
            // Pause Walking Animation
            body.animationManager.paused = true
        }
        
        
        // Stop Backwards Movement (Left->Right)
        if body.physicsBody.velocity.x < 0 && acceleration.x > 0 {
            body.physicsBody.velocity.x = acceleration.x
            body.physicsBody.applyImpulse(acceleration)
        }
        
        // X Limiter (Left->Right)
        if body.physicsBody.velocity.x > maxVelocity.x && acceleration.x > 0 {
            body.physicsBody.velocity.x = maxVelocity.x
        }
        
        // X Limiter (Right->Left)
        if body.physicsBody.velocity.x < maxVelocity.x && acceleration.x < 0 {
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
    
    func reverse() {
        
        body.physicsBody.velocity = ccpMult(body.physicsBody.velocity,-1)
        
        // Flip Mode
        maxVelocity = ccpMult(maxVelocity,-1)
        acceleration = ccpMult(acceleration,-1)
        
        // Flip Sprite
        body.flipX = !body.flipX
        
    }
    
    func isDrowning() {
        drown = true
        self.body.physicsBody.velocity.x = 0
        self.unscheduleAllSelectors()
    }
    
}

// MARK:- Equatable

func ==(lhs: Character, rhs: Character) -> Bool {
    return lhs.equateStamp == rhs.equateStamp
}