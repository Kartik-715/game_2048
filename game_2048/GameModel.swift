//
//  GameModel.swift
//  game_2048
//
//  Created by Kartik Gupta on 07/12/19.
//  Copyright © 2019 Kartik Gupta. All rights reserved.
//

import Foundation
import SwiftUI

class GameModel : ObservableObject
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
        assert(x >= 0 && x < dimension && y >= 0 && y < dimension)
        if case .empty = gameBoard[x,y]
        {
            gameBoard[x,y] = TileObject.tile(v)
            print("Inserted Tile at \(x),\(y)")
            // TELL THE GAME BOARD VIEW TO INSERT TILE TOO DELEGATE //
        }
    }
    
    func insertTileAtRandomLocation()
    {
        // Get Empty Spots //
        let spots = getEmptySpots()
        
        let n = spots.count
        let r = Int(arc4random_uniform(UInt32(n-1)))
        
        let tileLocation = spots[r]
        
        insertTile(at: tileLocation, value: 2)

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
                command.completion(changed)
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
        
        
        let coordinateGen =
        { (iteration: Int) -> [(Int,Int)] in
            var buffer: [(Int,Int)] = []
            
            for i in 0..<self.dimension
            {
                switch d
                {
                    case .down: buffer.append((self.dimension - i - 1, iteration))
                    case .up: buffer.append((i,iteration))
                    case .left: buffer.append((iteration, i))
                    case .right: buffer.append((iteration, self.dimension - i - 1))
                }
                
            }
            
            
            return buffer
        }
        
        // This Closure on taking input iteration returns the list or column of rows that have to be manipulated
        
        for i in 0..<self.dimension
        {
            let coords = coordinateGen(i)
            
            let tiles = coords.map()
            {
                (c: (Int,Int)) -> TileObject in
                let (x,y) = c
                return gameBoard[x,y]
            }
            
            // I now have a list of tile objects on whom I have to work! //
            
            let orders = mergeTiles(group: tiles)
            boardSituationChanged = (orders.count > 0 ? true : boardSituationChanged)
            
            for order in orders
            {
                switch(order)
                {
                case let MoveOrder.moveOneTile(s,d,v):
                    let (x1,y1) = coords[s]
                    let (x2,y2) = coords[d]
                    print("Move one from \(s) to \(d)")
                    
                    self.gameBoard[x1,y1] = TileObject.empty
                    self.gameBoard[x2,y2] = TileObject.tile(v)
                    
                    // INFORM DELEGATE //
                    
                    
                case let MoveOrder.moveTwoTiles(s1,s2,d,v):
                    let (x1,y1) = coords[s1]
                    let (x2,y2) = coords[s2]
                    let (x3,y3) = coords[d]
                    
                    self.gameBoard[x1,y1] = TileObject.empty
                    self.gameBoard[x2,y2] = TileObject.empty
                    self.gameBoard[x3,y3] = TileObject.tile(v)
                    print("Move two from \(s1),\(s2) to \(d)")
                    
                    // Increase score HERE //
                    
                    // Inform Delegate //
                }
            }
            
        }
        return boardSituationChanged
    }
    
    func checkIfSameValue(a: (Int,Int), b: (Int,Int)) -> Bool
    {
        let x,y,x2,y2: Int
        (x,y) = a
        (x2,y2) = b
        assert(x >= 0 && x < dimension && y >= 0 && y < dimension)
        assert(x2 >= 0 && x2 < dimension && y2 >= 0 && y2 < dimension)
        
        let val1 = gameBoard[x,y].getValue()
        let val2 = gameBoard[x2,y2].getValue()
        
        return ( (val1 == val2) && val1 > 0 && val2 > 0  )

    }
    
    
    func mergeTiles(group: [TileObject]) -> [MoveOrder]
    {
        var orders : [MoveOrder] = []
        var afterCollapseGroup: [TileObject] = []
        let n = group.count
        
        for (idx, tile) in group.enumerated()
        {
            if case .empty = tile
            {
                continue ;
            }
            
            if(idx != afterCollapseGroup.count)
            {
                let newOrder = MoveOrder.moveOneTile( from: idx, to: afterCollapseGroup.count, value: tile.getValue() )
                orders.append(newOrder)
            }
            
            afterCollapseGroup.append(tile)
            
        }
        
        for tile in group
        {
            if case .empty = tile
            {
                afterCollapseGroup.append(tile)
            }
        }
        
        // NOW I HAVE UPDATED TILES //
        
        var mergingOrders: [MoveOrder] = []
        var mergedCounts = 0
        var skipNext = false
        
        for (idx,tile) in afterCollapseGroup.enumerated()
        {
            if(skipNext)
            {
                skipNext = false
                continue
                
            }
            // Check if i can merge the current tile with the next one ? //
            if(tile.getValue() == 0 )
            {
                break
            }
            
            let t2 = (idx < n - 1) ? afterCollapseGroup[idx+1] : TileObject.empty
            
            if(tile.getValue() == t2.getValue())
            {
                let newOrder = MoveOrder.moveTwoTiles(s1: idx, s2: idx+1, d: idx - mergedCounts, value: t2.getValue() * 2)
                mergedCounts += 1
                mergingOrders.append(newOrder)
                skipNext = true
            }
            else
            {
                if(mergedCounts > 0)
                {
                    let x = mergedCounts
                    let newOrder = MoveOrder.moveOneTile(from: idx, to: idx - x, value: tile.getValue())
                    mergingOrders.append(newOrder)
                }
            }
            
        }
        
        orders.append(contentsOf: mergingOrders)
        
        return orders
    }
    
    func userHasLost() -> Bool
    {
        return getEmptySpots().count == 0
    }
    
    @objc func upMove()
    {
        print("Queued A up Move")
        self.queueMove(direction: .up)
        {
            (changed: Bool) -> () in
            if(changed)
            {
                self.followUp()
            }
            
        }
        
    }
    
    @objc func downMove()
    {
        print("Queued A down Move")
        self.queueMove(direction: .down)
        {
            (changed: Bool) -> () in
            if(changed)
            {
                self.followUp()
            }
            
        }
        
    }
    
    @objc func leftMove()
    {
        print("Queued A left Move")
        self.queueMove(direction: .left)
        {
            (changed: Bool) -> () in
            if(changed)
            {
                self.followUp()
            }
            
        }
        
    }
    
    @objc func rightMove()
    {
        print("Queued A right Move")
        self.queueMove(direction: .right)
        {
            (changed: Bool) -> () in
            if(changed)
            {
                self.followUp()
            }
            
        }
        
    }
    
    func followUp()
    {
        self.insertTileAtRandomLocation()
        // GIVE ME BOARD SITUATION //
        
        for i in 0..<dimension
        {
            for j in 0..<dimension
            {
                print(gameBoard[i,j].getValue(), terminator: " ")
            }
            print("")
        }
        
        
        if(self.userHasLost())
        {
            let alertView = UIAlertView()
            alertView.title = "Defeat"
            alertView.message = "You lost..."
            alertView.addButton(withTitle: "Cancel")
            alertView.show()
        }
    }
    
    
}
