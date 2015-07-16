import Foundation

class CharacterFrog : Character {
    
    override func didLoadFromCCB() {
        super.didLoadFromCCB()
        maxVelocity = ccpAdd(maxVelocity,ccp(0,100)) // Jump Higher
        body.physicsBody.mass = 0.05 // Lighter
    }
    
}
