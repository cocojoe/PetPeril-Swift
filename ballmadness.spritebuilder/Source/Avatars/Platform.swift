import Foundation

class Platform : CCNode {
    
    weak var pillar: CCSprite!
    
    func didLoadFromCCB() {
        pillar.physicsBody.type = .Static
        pillar.physicsBody.surfaceVelocity = ccp(15,0)
    }
    
}
