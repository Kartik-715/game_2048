//
//  Moves.swift
//  game_2048
//
//  Created by Kartik Gupta on 07/12/19.
//  Copyright © 2019 Kartik Gupta. All rights reserved.
//

import Foundation


enum MoveDirection
{
    case up,down,left,right
}

struct MoveCommand
{
    let direction: MoveDirection
    let completion: (Bool) -> ()
}

enum MoveOrder
{
    case moveOneTile(from: Int, to: Int, value: Int)
    case moveTwoTiles(s1: Int, s2: Int, d: Int, value: Int)
}

