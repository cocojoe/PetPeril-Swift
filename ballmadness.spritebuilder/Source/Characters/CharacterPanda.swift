import Foundation

class CharacterPanda : Character {
    
    override func didLoadFromCCB() {
        super.didLoadFromCCB()
        maxVelocity = ccpAdd(maxVelocity,ccp(-10,0)) // Slower
        body.physicsBody.mass = 0.2 // Heavier
    }
    
}
