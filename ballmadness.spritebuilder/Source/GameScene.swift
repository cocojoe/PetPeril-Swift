import Foundation

class GameScene : CCNode,CCPhysicsCollisionDelegate {
    
    // Helper Information
    let designSize = CCDirector.sharedDirector().designSize
    
    // Core Nodes
    weak var physicsWorld: CCPhysicsNode!
    
    // Groups
    var mechanical: [PlatformControl?] = []
    var characters: [Character?] = []
    
    // Level Loading
    weak var levelLoader: CCNode!
    
    // Essential Infrmation
    var spawnPoint: CGPoint = CGPointZero
    
    // Block Excessive Spawn
    var canSpawn = true
    
    // UX Node(s)
    weak var uxHiddenLayer: CCNode!
    
    func didLoadFromCCB() {
        
        // Touch Setup
        self.userInteractionEnabled = true
        self.multipleTouchEnabled = true
        
        // Physics Setup
        physicsWorld.collisionDelegate = self
        physicsWorld.debugDraw = false
        physicsWorld.space.damping = 0.90
        
        // Create World
        initialiseWorld()
        
        // Any Buttons Require Delegate Setting to Self
        registerButtonDelegates(self)
        
        // Spawn Characters
        physicsWorld.spawnCharacter()
        
        // Schedules
        physicsWorld.registerSchedules()
    }
    
    // MARK: - Content Creation
    
    func initialiseWorld() {
        
        // Load Level
        let levelNode = CCBReader.load("Mountain Levels/Level2")
        levelLoader.addChild(levelNode)
        
        for childNode in levelNode.children as! [CCNode] {
            
            // Enable Control for Tagged Platforms
            if childNode.name == "control" {
                
                let platformNode = childNode as! PlatformControl
                platformNode.setup()
                
                mechanical.append(platformNode)
            }
            
            // Grab Spawn Point
            if childNode is Spawn {
                spawnPoint = childNode.position
                childNode.visible = false
            }
        }
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
        
        let character: Character = characterBody.parent as! Character
        killCharacter(character)
        
        return false
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, platform platformBody: CCNode!, character characterBody: CCNode!) -> Bool {
        
        let character: Character = characterBody.parent as! Character
        character.nodesTouching+=1
        
        return true
    }
    
    func ccPhysicsCollisionSeparate(pair: CCPhysicsCollisionPair!, platform platformBody: CCNode!, character characterBody: CCNode!) -> Bool {
        
        let character: Character = characterBody.parent as! Character
        
        character.nodesTouching-=1
        
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, character characterBody: CCNode!, characterGoal: Goal!) -> Bool {
        
        // Destroy Character
        let character: Character = characterBody.parent as! Character
        
        // Remove Character
        physicsWorld.space.addPostStepBlock({
            self.removeCharacter(character)
            }, key:character)
        
        // Counter
        
        return true
    }
    
    func ccPhysicsCollisionPreSolve(pair: CCPhysicsCollisionPair!, character characterBody: CCNode!, water: WaterNode!) -> Bool {
        
        // Character
        let character: Character = characterBody.parent as! Character
        
        // Splash
        water.applyBuoyancy(pair)
        
        if character.drown == true {
            return false
        } else {
            //Character Position
            let particlePosition = character.convertToWorldSpace(characterBody.position)
            
            // Load Particle
            let particle: CCParticleSystem = CCParticleSystem(file: "water_particle.plist")
            particle.position = particlePosition
            particle.autoRemoveOnFinish = true
            self.addChild(particle)
        }
        
        // Drown
        for shape in character.body.physicsBody.body.shapes() {
            
            let accessShape = shape as! ChipmunkShape
            accessShape.mass = 100
        }
        
        character.isDrowning()
        
        return false
    }
    
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, platform platformBody: CCNode!, water: WaterNode!) -> Bool {
        
        let platform: PlatformControl = platformBody.parent as! PlatformControl
        water.applyBuoyancy(pair)
        
        //Character Position
        let particlePosition = platform.convertToWorldSpace(platformBody.position)
        
        // Load Particle
        let particle: CCParticleSystem = CCParticleSystem(file: "water_particle.plist")
        particle.position = particlePosition
        particle.autoRemoveOnFinish = true
        self.addChild(particle)
        
        return false
    }
    
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, character characterBody: CCNode!, death deathBody: CCNode!) -> Bool {
        
        // Destroy Character
        let character: Character = characterBody.parent as! Character
        
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
    
    func killCharacter(character: Character) {
        
        // Visible
        character.visible = true
        
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
        
        for (index,arrayCharacter) in characters.enumerate() {
            if character==arrayCharacter {
                characters.removeAtIndex(index)
            }
        }
        
        // Remove From Scene
        character.removeFromParent()
    }
    
    // MARK: - House keeping
    
    func cleanScene() {
        
        unscheduleAllSelectors()
        
        // Clear Characters
        characters.removeAll(keepCapacity: false)
        
        // Clear Control Platforms
        mechanical.removeAll(keepCapacity: false)
    }
    
}

// MARK:- UX Delegate
extension GameScene{
    
    func retryButton() {
        cleanScene()
        
        let gameScene: CCScene = CCBReader.loadAsScene("GameScene")
        CCDirector.sharedDirector().replaceScene(gameScene);
    }
    
    func exitButton() {
        cleanScene()
        
        let gameScene: CCScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(gameScene);
    }
    
    func pauseButton() {
        // Suspend / Resume Physics World (Contains Game, Excludes Ux)
        physicsWorld.paused = !physicsWorld.paused
        
        // Hide/Show Ux Extras Node
        uxHiddenLayer.visible = !uxHiddenLayer.visible
    }
    
}

// MARK:- Extend Physics
extension CCPhysicsNode {
    
    func spawnCharacter() {
        
        let parentNode = self.parent as! GameScene
        
        // Spawn Disabled Check
        if parentNode.canSpawn == false {
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
            print("No Valid Character")
            return
        }
        
        let characterNode = CCBReader.load(characterName) as! Character
        characterNode.position = parentNode.spawnPoint
        addChild(characterNode)
        
        parentNode.characters.append(characterNode)
    }
    
    func registerSchedules() {
        self.schedule(#selector(CCPhysicsNode.spawnCharacter), interval: 2.0)
    }
}