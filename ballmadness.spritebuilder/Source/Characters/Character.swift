import Foundation

class Character : CCNode {
    
    var body: CCSprite!
    let acceleration: CGPoint = ccp(0.5,0.0)
    let maxVelocity: CGPoint = ccp(20.0,0.0)
    
    func didLoadFromCCB() {
    }
    
}
