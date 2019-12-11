//
//  TileView.swift
//  game_2048
//
//  Created by Kartik Gupta on 11/12/19.
//  Copyright © 2019 Kartik Gupta. All rights reserved.
//

import SwiftUI

enum TileStyle
{
    case empty
    case two
    case four
    case eight
    case sixteen
    case rest
    
    
    init(_ value: Int)
    {
        switch value
        {
        case 0: self = .empty
        case 2: self = .two
        case 4: self = .four
        case 8: self = .eight
        case 16: self = .sixteen
        default: self = .rest
        }
    }
    
    var backGroundColor: Color
    {
        switch self
        {
        case .empty: return .tileEmpty
        case .two: return .tileTwo
        case .four: return .tileFour
        case .eight: return .tileEight
        case .sixteen: return .tileSixteen
        case .rest: return .tileMax
        }
    }
    
    var foregroundColor: Color
    {
        switch self {
        case .two,.four:
            return .tileDarkTitle
        default:
            return .white
        }
    }
    
}




struct TileView: View {
    let value: Int
    let style: TileStyle
    let title: String
    let size : CGFloat = 70
    
    init(_ v: Int) {
        self.value = v
        self.style = TileStyle(v)
        title = v == 0 ? "" : String(v)
    }
    
    private var fontSize: CGFloat {
        switch String(value).count {
        case 1, 2:
            return 30
        case 3:
            return 28
        default:
            return 22
        }
    }
    
    private var shadowColor: Color {
        value == 2048 ? .yellow : .clear
    }
    
    var body: some View {
        Text(title)
            .font(.system(size: fontSize, weight: .black, design: .rounded))
            .foregroundColor(style.foregroundColor)
            .frame(width: size, height: size)
            .background(style.backGroundColor)
            .cornerRadius(3)
            .shadow(color: shadowColor, radius: 4, x:0, y:0)
    }
}

struct TileView_Previews: PreviewProvider {
    static var previews: some View {
        Group
        {
            TileView(2048)
            TileView(2)
            TileView(4)
            TileView(8)
            TileView(16)
            TileView(32)
            TileView(64)
                
        }.previewLayout(.fixed(width: 100, height: 100))
        
    }
}
