import Foundation

class DeathRotor : Death {
    
    override func didLoadFromCCB() {
        super.didLoadFromCCB()
        
        // Rotation
        let rotation = CCActionRotateBy(duration: 1.0,angle: 360)
        body.runAction(CCActionRepeatForever(action:rotation))
        
        /*
         // Movement
         let movementOne = CCActionMoveBy(duration: 2.0, position: ccp(-568,0))
         var sequence    = CCActionSequence(array: [movementOne,movementOne.reverse()])
         
         runAction(CCActionRepeatForever(action:sequence))
         */
    }
}
