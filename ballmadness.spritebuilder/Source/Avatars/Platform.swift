import Foundation

class Platform : CCNode {
    
    var pillar: CCSprite!
    
    func didLoadFromCCB() {
        pillar.physicsBody.type = .Static
        pillar.physicsBody.surfaceVelocity = ccp(10,0)
    }
    
}
