import Foundation

class GameScene : CCNode,CCPhysicsCollisionDelegate {
    
    // Helper Information
    let designSize = CCDirector.sharedDirector().designSize
    
    // Core Nodes
    var physicsWorld: CCPhysicsNode!
    
    // Groups
    var mechanical: [PlatformControl?] = []
    var characters: [Character?] = []
    
    // Level Loading
    var levelLoader: CCNode!
    
    // Important Points
    var startPoint: CGPoint = CGPointZero
    
    func didLoadFromCCB() {
        
        // Touch Setup
        self.userInteractionEnabled = true
        self.multipleTouchEnabled = true
        
        // Physics Setup
        physicsWorld.collisionDelegate = self
        physicsWorld.debugDraw = false
        physicsWorld.space.damping = 0.80
        
        // Create World
        initialiseWorld()
        
        // Spawn Characters
        spawnCharacter()
        self.schedule("spawnCharacter", interval: 2.0)
    }
    
    // MARK: - Content Creation
    
    func initialiseWorld() {
        
        // Load Level
        let levelNode = CCBReader.load("Mountain Levels/Level1")
        levelLoader.addChild(levelNode)
        
        for childNode in levelNode.children as! [CCNode] {
            
            // Enable Control for Tagged Platforms
            if childNode.name == "control" {
                
                var platformNode = childNode as! PlatformControl
                platformNode.setup()
                
                mechanical.append(platformNode)
            }
            
            // Grab Start Point
            if childNode.name == "startPoint" {
                startPoint = childNode.position
                childNode.visible = false
            }
        }
    }
    
    func spawnCharacter() {
        let characterNode = CCBReader.load("Character Objects/TheCat") as! Character
        characterNode.position = startPoint
        physicsWorld.addChild(characterNode)
        
        characters.append(characterNode)
    }
    
    // MARK: - Game Loop
    
    override func update(delta: CCTime) {
    }
    
    // MARK: - Touch Handlers
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        // Nothing To Do
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        let newLocation: CGPoint = touch.locationInView(CCDirector.sharedDirector().view as! CCGLView)
        let lastLocation: CGPoint = touch.previousLocationInView(CCDirector.sharedDirector().view as! CCGLView)
        let touchDiff: CGPoint = ccpSub(lastLocation, newLocation)
        
        for platform in mechanical {
            platform?.processMove(touchDiff)
        }
    }
    
    // MARK: - Physics
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterExtraLife: Sensor!, character characterBody: CCNode!) -> Bool {
        println("SecondChance v Character")
        
        var character: Character = characterBody.parent as! Character
        moveCharacter(character,targetPosition: startPoint)
        
        return false
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, platform: PlatformControl!, character characterBody: CCNode!) -> Bool {
        println("Character/Platform Begin")
        var character: Character = characterBody.parent as! Character
        character.active = true
        
        return true
    }
    
    func ccPhysicsCollisionSeparate(pair: CCPhysicsCollisionPair!, platform: PlatformControl!, character characterBody: CCNode!) -> Bool {
        println("Character/Platform End")
        var character: Character = characterBody.parent as! Character
        character.active = false
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, character characterBody: CCNode!, characterGoal: Goal!) -> Bool {
        
        // Destroy Character
        removeCharacter(characterBody)
        
        // Counter
        
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, character characterBody: CCNode!, death: Death!) -> Bool {
        
        // Destroy Character
        removeCharacter(characterBody)
        
        // Add Effects
        shake()
        
        return false
    }
    
    // MARK: - UX
    
    func restart() {
        cleanScene()
        
        var gameScene: CCScene = CCBReader.loadAsScene("GameScene")
        CCDirector.sharedDirector().replaceScene(gameScene);
    }
    
    // MARK: - Effects
    
    func shake() {
        self.runAction(CCActionShake(duration: 0.25, amplitude: ccp(CGFloat.random(min:CGFloat(1),max:CGFloat(5)) , CGFloat.random(min:CGFloat(1),max: CGFloat(5))), dampening:true, shakes:0))
    }
    
    // MARK: - Game Keeping
    
    func moveCharacter(character: Character, targetPosition: CGPoint) {
    
        // Disable Physics
        character.disablePhysics()
        
        // Action
        let actionMove = CCActionMoveTo(duration: 2.0, position: targetPosition)
        let actionBlock = CCActionCallBlock(block: {
            character.enablePhysics()
        })
        let actionSequence = CCActionSequence(array: [actionMove,actionBlock])
        
        character.body.runAction(actionSequence)
        
        //
        
    }
    
    func removeCharacter(characterBody: CCNode) {
        
        var character: Character = characterBody.parent as! Character
        
        for (index,arrayCharacter) in enumerate(characters) {
            if character==arrayCharacter {
                characters.removeAtIndex(index)
            }
        }
        
        // Remove Character
        physicsWorld.space.addPostStepBlock({
            character.removeFromParent()
            }, key:character)
    }
    
    // MARK: - House keeping
    
    func cleanScene() {
        
        // Clear Characters
        characters.removeAll(keepCapacity: false)
        
        // Clear Control Platforms
        mechanical.removeAll(keepCapacity: false)
    }
    
}