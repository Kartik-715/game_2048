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
        view.addGestureRecognizer(Swipe(.up)
        {
            self.rootView.gameModel.upMove()
        })
        
        view.addGestureRecognizer(Swipe(.left)
        {
            self.rootView.gameModel.leftMove()
        })
        
        view.addGestureRecognizer(Swipe(.right)
        {
            self.rootView.gameModel.rightMove()
        })
        
        view.addGestureRecognizer(Swipe(.down)
        {
            self.rootView.gameModel.downMove()
        })
        
    }

    
}
