//
//  gameBoardView.swift
//  game_2048
//
//  Created by Kartik Gupta on 09/12/19.
//  Copyright © 2019 Kartik Gupta. All rights reserved.
//

import SwiftUI

struct GameBoardView: View
{
    
    let dimension: Int
    @ObservedObject var board: SquareGameBoard<TileObject>
    
    
    var body: some View
    {
        VStack
        {
            ForEach(0..<dimension, id: \.self)
            {
                row in
                HStack
                {
                    ForEach(0..<self.dimension, id: \.self)
                    {
                        column in
                        return TileView(self.board[row,column].getValue()) // Fill Appropriately with board values
                    }
                }.padding(4)
            }
        }
        .padding(8)
        .background(Color.boardBackground)
        .cornerRadius(4)
        
    }
}

struct GameBoardView_Previews: PreviewProvider {
    static var previews: some View {
        GameBoardView(dimension: 3, board: SquareGameBoard<TileObject>(dimension: 3, initValue: .empty))
    }
}
