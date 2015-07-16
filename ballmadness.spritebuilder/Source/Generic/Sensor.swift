import Foundation

class Sensor : CCNode {
    
    weak var sensor: CCNode!
    
    func didLoadFromCCB() {
        sensor.physicsBody.sensor = true
    }
}
