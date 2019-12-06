//
//  GameModel.swift
//  game_2048
//
//  Created by Kartik Gupta on 07/12/19.
//  Copyright © 2019 Kartik Gupta. All rights reserved.
//

import Foundation


protocol GameModelProtocol
{
    func insertTile(at: (Int,Int), value: Int) -> Void
}


class GameModel : NSObject
{
    var gameBoard: SquareGameBoard<TileObject>
    let dimension: Int
    var timer: Timer
    var queue: [MoveCommand]
    let queueMoveDelay = 0.3 // 0.3 seconds between adjacent moves //
    
    
    init(dimension d: Int)
    {
        gameBoard = SquareGameBoard<TileObject>(dimension: d, initValue: TileObject.empty)
        dimension = d
        timer = Timer()
        queue = []
    }
    
    func insertTile(at location: (Int, Int), value v: Int) -> Void
    {
        let (x,y) = location
        if case .empty = gameBoard[x,y]
        {
            gameBoard[x,y] = TileObject.tile(v)
            // TELL THE GAME BOARD VIEW TO INSERT TILE TOO //
        }
    }
    
    func getEmptySpots() -> [(Int,Int)]
    {
        var spots: [(Int,Int)] = []
        
        for i in 0..<dimension
        {
            for j in 0..<dimension
            {
                if case .empty = gameBoard[i,j]
                {
                    spots.append((i,j))
                }
            }
        }
        
        return spots
    }
    
    
    func queueMove(direction: MoveDirection, onCompletion: @escaping (Bool) -> ())
    {
        queue.append(MoveCommand(direction: direction, completion: onCompletion))
        if(!timer.isValid)
        {
            tryToRun(timer)
        }
        
    }
    
    @objc func tryToRun(_ : Timer)
    {
        if(queue.count == 0)
        {
            return
        }
        
        var changed = false
        
        while(!queue.isEmpty)
        {
            let command = queue.removeFirst()
            changed = performMove(direction: command.direction)
            
            if changed
            {
                break
            }
            
            // If nothing changed run again! //
        }
        
        if(changed)
        {
            timer = Timer.scheduledTimer(timeInterval: queueMoveDelay, target: self, selector: #selector(tryToRun(_:)), userInfo: nil, repeats: false)
        }
    }
    
    func performMove(direction d: MoveDirection) -> Bool
    {
        var boardSituationChanged = false
        
        switch d {
        case .down:
            <#code#>
        default:
            <#code#>
        }
        
        return boardSituationChanged
    }
    
    
}
