import Foundation

class CharacterPanda : Character {
    
    override func didLoadFromCCB() {
        super.didLoadFromCCB()
        maxVelocity = ccpAdd(maxVelocity,ccp(-10,0)) // Slower
    }
    
}
