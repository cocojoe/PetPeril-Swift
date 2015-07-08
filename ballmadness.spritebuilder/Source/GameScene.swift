import Foundation

class GameScene : CCNode {
    
    // Helper Information
    let designSize = CCDirector.sharedDirector().designSize
    
    // Core Nodes
    var physicsWorld: CCPhysicsNode!
    
    // Mechanical Groups
    var mechanicalGroupLeft: [Platform?] = []
    var mechanicalGroupRight: [Platform?] = []
    
    func didLoadFromCCB() {
        
        // Touch Setup
        self.userInteractionEnabled = true
        self.multipleTouchEnabled = true
        
        // Physics Setup
        physicsWorld.debugDraw = false
        //physicsWorld.positionType = CCPositionType(xUnit: .Normalized, yUnit: .Normalized, corner: .BottomLeft)
        
        // Create World
        initialiseWorld()
    }
    
    // MARK: - Content Creation
    
    func initialiseWorld() {
        var generatedWidth: CGFloat = 0
        var index: Int = 1
        var lastPosition = ccp(0,0)

        while generatedWidth < designSize.width {
            
            var newPlatform = generatePlatform()
            let platformWidth = newPlatform.pillar.contentSize.width
            generatedWidth += platformWidth
            
            // Platform Position
            newPlatform.position = lastPosition
            lastPosition = ccpAdd(lastPosition,ccp(platformWidth,0))
            
            // Platform Constraints
            newPlatform.addConstraints()
            
            // Add Child
            physicsWorld.addChild(newPlatform, z: 1)
            
            // Assign to Mechanic
            if(index % 2 == 0) {
                // Even Number
                mechanicalGroupLeft.append(newPlatform)
                newPlatform.pillar.color = CCColor(red: 0.8, green: 0.8, blue: 0.8)
            } else {
                // Odd Number
                mechanicalGroupRight.append(newPlatform)
                newPlatform.pillar.color = CCColor(red: 0.4, green: 0.4, blue: 0.4)
            }
            index++
        }
    }
    
    func generatePlatform() -> Platform {
        var platform:Platform = CCBReader.load("Platform") as! Platform
        
        // Modify Pillar Width Dynamically
        platform.pillar.contentSize.width *= platform.scaleRandomiser.randomItem()
        
        // Create Physics Body
        platform.pillar.physicsBody = CCPhysicsBody(rect: platform.pillar.boundingBox(), cornerRadius: 0)
        platform.pillar.physicsBody.type = .Static
        
        return platform;
    }
    
    // MARK: - Touch Handlers
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        // Multi Touch
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        let newLocation: CGPoint = touch.locationInView(CCDirector.sharedDirector().view as! CCGLView)
        let lastLocation: CGPoint = touch.previousLocationInView(CCDirector.sharedDirector().view as! CCGLView)
        let touchDiff: CGPoint = ccpSub(lastLocation, newLocation)
        
        if newLocation.x < (designSize.width*0.5) {
            // Left Move
            for platform in mechanicalGroupLeft {
                platform?.position = ccpAdd(platform!.position,ccp(0,touchDiff.y))
                platform?.checkConstraints()
            }
        } else if newLocation.x > (designSize.width*0.5) {
            // Right Move
            for platform in mechanicalGroupRight {
                platform?.position = ccpAdd(platform!.position,ccp(0,touchDiff.y))
                platform?.checkConstraints()
            }
        }
    }
    
}