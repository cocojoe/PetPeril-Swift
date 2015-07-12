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
        physicsWorld.debugDraw = true
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
         println(characterNode.equateStamp)
        
        characters.append(characterNode)
    }
    
    // MARK: - Game Loop
    
    override func update(delta: CCTime) {
        
        // Update Game Characters
        for character in characters {
            character?.update(delta)
        }
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
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterExtraLife: Sensor!, character: Character!) -> Bool {
        println("SecondChance v Character")
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, platform: PlatformControl!, character: Character!) -> Bool {
        println("Platform v Character")
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterGoal: Goal!, character: Character!) -> Bool {
        println("Goal v Character")
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, character characterBody: CCNode!, death: Death!) -> Bool {
        println("Death")
        
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
        
        // Add Effects
        
        return false
    }
    
    // MARK: - UX
    
    func restart() {
        cleanScene()
        
        var gameScene: CCScene = CCBReader.loadAsScene("GameScene")
        CCDirector.sharedDirector().replaceScene(gameScene);
    }
    
    // MARK: - Housekeeping
    
    func cleanScene() {
        
        // Clear Characters
        characters.removeAll(keepCapacity: false)
        
        // Clear Control Platforms
        mechanical.removeAll(keepCapacity: false)
    }
    
}