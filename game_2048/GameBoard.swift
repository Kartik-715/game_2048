//
//  GameBoard.swift
//  game_2048
//
//  Created by Kartik Gupta on 07/12/19.
//  Copyright © 2019 Kartik Gupta. All rights reserved.
//

import Foundation

enum TileObject
{
    case empty
    case tile(Int)
}


struct SquareGameBoard<T>
{
    let dimension: Int
    var board:[T]
    
    init(dimension d: Int, initValue: T)
    {
        board = [T](repeating: initValue, count: d*d)
        dimension = d
    }
    
    subscript(row: Int, col: Int) -> T
    {
        get
        {
            assert(row >= 0 && row < dimension)
            assert(col >= 0 && col < dimension)
            return board[row*dimension + col]
        }
        
        set
        {
            assert(row >= 0 && row < dimension)
            assert(col >= 0 && col < dimension)
            board[row*dimension + col] = newValue
        }
    }
    
    
    mutating func setAll(to val: T)
    {
        for i in 0..<dimension
        {
            for j in 0..<dimension
            {
                self[i,j] = val
            }
        }
        
    }
    
    
}
