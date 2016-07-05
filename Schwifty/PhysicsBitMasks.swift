//
//  PhysicsBitMasks.swift
//  Schwifty
//
//  Created by Gabriel Querbes on 7/5/16.
//  Copyright © 2016 Fourteen66. All rights reserved.
//

import Foundation

/**
 Bit masks for physics collision
*/
struct PhysicsBitMasks {
    let none : UInt32 = 0
    let all : UInt32 = UInt32.max
    let paddle : UInt32 = 0x1     // 1
    let obstacle : UInt32 = 0x1 << 1      // 2
    let powerUp : UInt32 = 0x1 << 2    // 4
    let walls : UInt32 = 0x1 << 3
}