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
    var canSpawn = true
    
    // Important Points
    var startPoint: CGPoint = CGPointZero
    
    func didLoadFromCCB() {
        
        // Touch Setup
        self.userInteractionEnabled = true
        self.multipleTouchEnabled = true
        
        // Physics Setup
        physicsWorld.collisionDelegate = self
        physicsWorld.debugDraw = false
        //physicsWorld.space.damping = 0.90
        
        // Create World
        initialiseWorld()
        
        // Any Buttons Require Delegate Setting to Self
        registerButtonDelegates()
        
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
        
        // Spawn Disabled Check
        if canSpawn == false {
            return
        }
        
        // Random Character
        var characterName: String?
        
        switch Int.random(min: 1, max: 3) {
        case 1:
            characterName = "Character Objects/TheCat"
        case 2:
            characterName = "Character Objects/ThePanda"
        case 3:
            characterName = "Character Objects/TheFrog"
        default:
            println("No Valid Character")
        }
        
        let characterNode = CCBReader.load(characterName) as! Character
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
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        for platform in mechanical {
            platform?.deadStop()
        }
    }
    
    // MARK: - Physics
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterSpawn: CCNode!, character characterBody: CCNode!) -> Bool {
        
        canSpawn = false
        
        return false
    }
    
    func ccPhysicsCollisionSeparate(pair: CCPhysicsCollisionPair!, characterSpawn: CCNode!, character characterBody: CCNode!) -> Bool {
        
        canSpawn = true
        
        return false
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterSoftDeath: Sensor!, character characterBody: CCNode!) -> Bool {
        
        var character: Character = characterBody.parent as! Character
        killCharacter(character)
        
        return false
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, platform platformBody: CCNode!, character characterBody: CCNode!) -> Bool {
        
        var character: Character = characterBody.parent as! Character
        var platform: PlatformControl = platformBody.parent as! PlatformControl
        
        return true
    }
    
    func ccPhysicsCollisionSeparate(pair: CCPhysicsCollisionPair!, platform platformBody: CCNode!, character characterBody: CCNode!) -> Bool {
        
        var character: Character = characterBody.parent as! Character
        var platform: PlatformControl = platformBody.parent as! PlatformControl
        
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, character characterBody1: CCNode!, character characterBody2: CCNode!) -> Bool {
        
        // Destroy Character
        var character1: Character = characterBody1.parent as! Character
        var character2: Character = characterBody2.parent as! Character
        
        // The Bigger Consumes
        if character1.body.scale >= character2.body.scale {
            character1.body.scale += 0.25
            
            // Remove Character
            physicsWorld.space.addPostStepBlock({
                self.removeCharacter(character2)
                }, key:character2)
        } else {
            character2.body.scale += 0.25
            
            // Remove Character
            physicsWorld.space.addPostStepBlock({
                self.removeCharacter(character1)
                }, key:character1)
        }
        
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, character characterBody: CCNode!, characterGoal: Goal!) -> Bool {
        
        // Destroy Character
        var character: Character = characterBody.parent as! Character
        
        // Remove Character
        physicsWorld.space.addPostStepBlock({
            self.removeCharacter(character)
            }, key:character)
        
        // Counter
        
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, character characterBody: CCNode!, death deathBody: CCNode!) -> Bool {
        
        // Destroy Character
        var character: Character = characterBody.parent as! Character
        var death: Death = deathBody.parent as! Death
        
        // Add Effects
        shake()
        
        //Character Position
        let decalPosition = character.convertToWorldSpace(characterBody.position)
        
        // Blood Effect Decal
        let decal: CCSprite = CCSprite(imageNamed:"Character Assets/decal_blood.png")
        decal.position = decalPosition
        decal.rotation = Float.random(min: 0, max: 360)
        self.addChild(decal, z: 10)
        
        // Action Sequence
        let actionFade  = CCActionFadeTo(duration: 0.5, opacity: 0)
        let actionBlock  = CCActionCallBlock(block:{
            decal.removeFromParent()
        })
        
        decal.runAction(CCActionSequence(array: [actionFade,actionBlock]))
        
        // Remove Character
        physicsWorld.space.addPostStepBlock({
            self.removeCharacter(character)
            }, key:character)
        
        return false
    }

    // MARK: - Effects
    
    func shake() {
        self.runAction(CCActionShake(duration: 0.25, amplitude: ccp(CGFloat.random(min:CGFloat(1),max:CGFloat(5)) , CGFloat.random(min:CGFloat(1),max: CGFloat(5))), dampening:true, shakes:0))
    }
    
    // MARK: - Game Keeping
    
    func killCharacter(character: Character) {
        
        // Disable Physics
        character.disablePhysics()
        
        // Action
        let actionMove  = CCActionMoveBy(duration: 1.5, position: ccp(0,200))
        let actionFade  = CCActionFadeTo(duration: 0.5, opacity: 0)
        let actionDelay = CCActionDelay(duration: 1.0)
        let actionFunc  = CCActionCallBlock(block:{
            self.removeCharacter(character)
        })
        
        character.body.animationManager.runAnimationsForSequenceNamed("Death")
        
        character.body.runAction(actionMove)
        character.body.runAction(CCActionSequence(array: [actionDelay,actionFade,actionFunc]))
    }
    
    func removeCharacter(character: Character) {
        
        for (index,arrayCharacter) in enumerate(characters) {
            if character==arrayCharacter {
                characters.removeAtIndex(index)
            }
        }
        
        // Remove From Scene
        character.removeFromParent()
    }
    
    // MARK: - House keeping
    
    func cleanScene() {
        
        // Clear Characters
        characters.removeAll(keepCapacity: false)
        
        // Clear Control Platforms
        mechanical.removeAll(keepCapacity: false)
    }
    
    func registerButtonDelegates() {
        
        // Any Buttons Require Delegate Setting to Self
        for childNode in self.children as! [CCNode] {
            
            // Enable Control for Tagged Platforms
            if childNode.name == "button" {
                
                var buttonNode = childNode as! Button
                buttonNode.delegate = self
            }
        }
    }
    
}

// MARK:- UX Delegate
extension GameScene: ButtonDelegate {
    
    func retryButton() {
        cleanScene()
        
        var gameScene: CCScene = CCBReader.loadAsScene("GameScene")
        CCDirector.sharedDirector().replaceScene(gameScene);
    }
    
}