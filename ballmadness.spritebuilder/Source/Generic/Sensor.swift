import Foundation

class Sensor : CCNode {
    
    var sensor: CCNode!
    
    func didLoadFromCCB() {
        sensor.physicsBody.sensor = true
        sensor.visible = false
    }
}
