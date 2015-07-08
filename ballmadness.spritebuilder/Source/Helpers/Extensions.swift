//
//  Extensions.swift
//  ballmadness
//
//  Created by Martin Walsh on 07/07/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

extension Array {
    func randomItem() -> T {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}