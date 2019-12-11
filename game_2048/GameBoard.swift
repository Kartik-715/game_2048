//
//  GameBoard.swift
//  game_2048
//
//  Created by Kartik Gupta on 07/12/19.
//  Copyright © 2019 Kartik Gupta. All rights reserved.
//

import Foundation
import SwiftUI

enum TileObject
{
    case empty
    case tile(Int)
    
    func getValue() -> Int
    {
        switch self
        {
            case .empty: return 0
            case let .tile(x): return x
        }
    }
}


class SquareGameBoard<T> : ObservableObject
{
    var dimension: Int
    @Published var board:[T]
    
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
            //print("Changed Value of board at \(row),\(col) to \(newValue)")
        }
    }
    
    
    func setAll(to val: T)
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
