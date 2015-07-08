import Foundation

class Platform : CCNode {
    
    var pillar: CCNode!
    
    var minVertical: CGFloat = 0
    var maxVertical: CGFloat = 0
    
    let scaleRandomiser: [CGFloat] = [1.25,1.5,1.75,2.0]
    let offsetRandomiser: [CGFloat] = [50,75,100,125]
    let minRandomiser: [CGFloat] = [200,150,100]
    let maxRandomiser: [CGFloat] = [0,25,50]
    
    func didLoadFromCCB() {
    }
    
    func addConstraints() {
        // Modify Starting Y
        self.position = ccpSub(position,ccp(0,offsetRandomiser.randomItem()))
        
        // Position Constraints
        minVertical = position.y - minRandomiser.randomItem()
        maxVertical = position.y + maxRandomiser.randomItem()
    }
    
    func checkConstraints() {
        
        println(position)

        // Check Constraints
        if position.y < minVertical {
            position.y = minVertical
        } else if position.y > maxVertical {
            position.y = maxVertical
        }
    }
    
    
}
