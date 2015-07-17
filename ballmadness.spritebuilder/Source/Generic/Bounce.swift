import Foundation

class Bounce : CCNode {
    
    weak var sensor: CCNode!
    
    func didLoadFromCCB() {
        sensor.physicsBody.sensor = true
        sensor.visible = false
    }
}
