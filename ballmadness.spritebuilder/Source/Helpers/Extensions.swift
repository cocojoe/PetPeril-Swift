//
//  Extensions.swift
//  ballmadness
//
//  Created by Martin Walsh on 07/07/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import CoreGraphics

// MARK: - Random Selection/Generators

extension Array {
    func randomItem() -> T {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

public extension Int {
    /**
    Returns a random integer between 0 and n-1.
    */
    public static func random(n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }
    /**
    Create a random num Int
    :param: lower number Int
    :param: upper number Int
    :return: random number Int
    By DaRkDOG
    */
    public static func random(#min: Int, max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max - min + 1))) + min
    }
}
public extension Double {
    /**
    Returns a random floating point number between 0.0 and 1.0, inclusive.
    By DaRkDOG
    */
    public static func random() -> Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    
    /**
    Create a random num Double
    :param: lower number Double
    :param: upper number Double
    :return: random number Double
    By DaRkDOG
    */
    public static func random(#min: Double, max: Double) -> Double {
        return Double.random() * (max - min) + min
    }
}
public extension Float {
    /**
    Returns a random floating point number between 0.0 and 1.0, inclusive.
    By DaRkDOG
    */
    public static func random() -> Float {
        return Float(arc4random()) / 0xFFFFFFFF
    }
    /**
    Create a random num Float
    :param: lower number Float
    :param: upper number Float
    :return: random number Float
    By DaRkDOG
    */
    public static func random(#min: Float, max: Float) -> Float {
        return Float.random() * (max - min) + min
    }
}
public extension CGFloat {
    /**
    Returns a random floating point number between 0.0 and 1.0, inclusive.
    By DaRkDOG
    */
    public static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    /**
    Create a random num CGFloat
    :param: lower number CGFloat
    :param: upper number CGFloat
    :return: random number CGFloat
    By DaRkDOG
    */
    public static func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random() * (max - min) + min
    }
}

// MARK:- Type Conversions

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    var CGFloatValue: CGFloat {
        return CGFloat((self as NSString).floatValue)
    }
}

// MARK:- Maths

extension CGFloat {
    var signum: Int {
        return (self < 0) ? -1 : (self > 0) ? +1 : 0;
    }
}

// MARK:- Cocos2D
extension CCNode:ButtonDelegate {
    
    func registerButtonDelegates(node: CCNode) {
        
        // Any Buttons Require Delegate Setting to Self
        for childNode in node.children as! [CCNode] {
            
            // Enable Control for Tagged Platforms
            if childNode.name == "button" {
                
                var buttonNode = childNode as! Button
                buttonNode.delegate = self
            }
            
            if childNode.children != nil {
                registerButtonDelegates(childNode)
            }
        }
    }
    
}
