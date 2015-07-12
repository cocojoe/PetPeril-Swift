import Foundation

class Death : CCNode {
    
    var body: CCSprite!
    
    func didLoadFromCCB() {
        body.physicsBody.sensor = true
    }
}
