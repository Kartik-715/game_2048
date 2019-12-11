//
//  GameViewController.swift
//  game_2048
//
//  Created by Kartik Gupta on 11/12/19.
//  Copyright © 2019 Kartik Gupta. All rights reserved.
//

import Foundation
import SwiftUI


class GameViewController: UIHostingController<gameScreen>
{
    init()
    {
        super.init(rootView: gameScreen(dimension:5))
        setupSwipeGestures()
        self.rootView.gameModel.insertTileAtRandomLocation()
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupSwipeGestures()
    {
        let upGesture = UISwipeGestureRecognizer(target: self.rootView.gameModel, action: #selector(self.rootView.gameModel.upMove))
        upGesture.numberOfTouchesRequired = 1
        upGesture.direction = .up
        
        view.addGestureRecognizer(upGesture)
        
        let leftGesture = UISwipeGestureRecognizer(target: self.rootView.gameModel, action: #selector(self.rootView.gameModel.leftMove))
        leftGesture.numberOfTouchesRequired = 1
        leftGesture.direction = .left
        
        view.addGestureRecognizer(leftGesture)
        
        let rightGesture = UISwipeGestureRecognizer(target: self.rootView.gameModel, action: #selector(self.rootView.gameModel.rightMove))
        rightGesture.numberOfTouchesRequired = 1
        rightGesture.direction = .right
        
        view.addGestureRecognizer(rightGesture)
        
        let downGesture = UISwipeGestureRecognizer(target: self.rootView.gameModel, action: #selector(self.rootView.gameModel.downMove))
        downGesture.numberOfTouchesRequired = 1
        downGesture.direction = .down
        
        view.addGestureRecognizer(downGesture)
    }

    
}
