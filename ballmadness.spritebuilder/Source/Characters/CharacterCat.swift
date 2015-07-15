import Foundation

class CharacterCat : Character {
    
    override func didLoadFromCCB() {
        super.didLoadFromCCB()
        maxVelocity = ccpAdd(maxVelocity,ccp(10,0)) // Faster Movement
    }
    
}
