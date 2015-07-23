import Foundation

class WorldNode : CCEffectNode {
    
    func didLoadFromCCB() {
        self.userInteractionEnabled = true
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        println("World Touched")
        //self.effect = nil
    }
    
}
