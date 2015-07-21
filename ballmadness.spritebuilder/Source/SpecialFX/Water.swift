import Foundation

class Water : WaterNode {
    
    override func onEnter() {
        super.onEnter()
        self.zOrder = 5 // Ensure Water on top
    }
    
}
