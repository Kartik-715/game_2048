//
//  gameScreen.swift
//  game_2048
//
//  Created by Kartik Gupta on 07/12/19.
//  Copyright © 2019 Kartik Gupta. All rights reserved.
//

import SwiftUI

struct gameScreen: View
{
    var gameModel: GameModel
    
    init(dimension: Int)
    {
        gameModel = GameModel(dimension: dimension)
    }
    
    var body: some View
    {
        VStack(alignment: .center, spacing: 10)
        {
            Text("2048").font(.system(size: 30, weight: .black, design: .rounded)).foregroundColor(Color.red).multilineTextAlignment(.center).lineLimit(2).cornerRadius(5.0)
            GameBoardView(dimension: gameModel.dimension, board: gameModel.gameBoard)
            //Spacer()
            Text("Enjoy The Game")
            
        }
        .frame(minWidth: .zero,
        maxWidth: .infinity,
        minHeight: .zero,
        maxHeight: .infinity,
        alignment: .center)
        .background(Color.gameBackground)
        .edgesIgnoringSafeArea(.all)
    }
}

struct gameScreen_Previews: PreviewProvider {
    static var previews: some View {
        gameScreen(dimension: 4)
    }
}
