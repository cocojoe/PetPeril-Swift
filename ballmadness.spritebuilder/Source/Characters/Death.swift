import Foundation

class Death : CCNode {
    
    weak var body: CCSprite!
    
    func didLoadFromCCB() {
        body.physicsBody.sensor = true
    }
}
