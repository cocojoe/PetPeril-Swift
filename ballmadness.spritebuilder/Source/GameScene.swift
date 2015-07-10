import Foundation

class GameScene : CCNode {
    
    // Helper Information
    let designSize = CCDirector.sharedDirector().designSize
    
    // Core Nodes
    var physicsWorld: CCPhysicsNode!
    
    // Mechanical Groups
    var mechanicalGroupLeft: [PlatformControl?] = []
    var mechanicalGroupRight: [PlatformControl?] = []
    
    // Level Loading
    var levelLoader: CCNode!
    
    func didLoadFromCCB() {
        
        // Touch Setup
        self.userInteractionEnabled = true
        self.multipleTouchEnabled = true
        
        // Physics Setup
        physicsWorld.debugDraw = false
        
        // Create World
        initialiseWorld()
    }
    
    // MARK: - Content Creation
    
    func initialiseWorld() {
        
        var index = 0
        
        // Load Level
        let levelNode = CCBReader.load("Mountain Levels/Level1")
        levelLoader.addChild(levelNode)
        
        for childNode in levelNode.children {
            
            if let match = childNode.name.rangeOfString("control", options: .RegularExpressionSearch) {
                
                var platformNode = childNode as! PlatformControl
                platformNode.setup(childNode.name)
                
                // Assign to Mechanic Group (Left / Right)
                if(index % 2 == 0) {
                    // Even Number
                    mechanicalGroupLeft.append(platformNode)
                } else {
                    // Odd Number
                    mechanicalGroupRight.append(platformNode)
                }
                index++
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
        
        if newLocation.x < (designSize.width*0.5) {
            // Left Move
            for platform in mechanicalGroupLeft {
                if platform?.enableControl == true {
                    platform?.position = ccpAdd(platform!.position,ccp(0,touchDiff.y))
                    platform?.checkConstraints()
                }
            }
        } else if newLocation.x > (designSize.width*0.5) {
            // Right Move
            for platform in mechanicalGroupRight {
                if platform?.enableControl == true {
                    platform?.position = ccpAdd(platform!.position,ccp(0,touchDiff.y))
                    platform?.checkConstraints()
                }
            }
        }
    }
    
}