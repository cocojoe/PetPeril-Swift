import Foundation

class GameScene : CCNode {
    
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
        physicsWorld.debugDraw = false
        physicsWorld.space.damping = 0.80
        
        // Create World
        initialiseWorld()
        
        // Spawn Characters
        spawnCharacter()
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
            
            // Enable Control for Tagged Platforms
            if childNode.name == "startPoint" {
                startPoint = childNode.position
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
        for character in characters {
            
            character!.body.physicsBody.applyImpulse(character!.acceleration)
            
            if character!.body.physicsBody.velocity.x > character!.maxVelocity.x {
                character!.body.physicsBody.velocity.x = character!.maxVelocity.x
            }
            
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
            if platform!.enableControl == true {
                // Dynamic Body Must Be Moved Directly (Not affected by Parent)
                platform?.position = ccpAdd(platform!.position,ccp(0,touchDiff.y*platform!.direction))
                platform!.validateConstraints()
            }
        }
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