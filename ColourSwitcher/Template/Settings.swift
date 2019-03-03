//
//  Settings.swift
//  ColourSwitcher
//
//  Created by Ant Milner on 03/03/2019.
//  Copyright © 2019 Ant Milner. All rights reserved.
//

import SpriteKit

enum PhysicsCategories              //Enumerate some physics properties

{
    static let none: UInt32 = 0     //unassigned 32 bit integer, means no physical simulation to take place
    static let ballCategory: UInt32 = 0x1           // 01
    static let switchCategory: UInt32 = 0x1  << 1     // 10
}

enum ZPositions                     //Enumerate some layer properties for each element
{
    static let label: CGFloat = 0
    static let ball: CGFloat = 1
    static let colorSwitch: CGFloat = 2
}
