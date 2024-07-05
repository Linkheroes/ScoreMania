//
//  GameIcon.swift
//  ScoreMania
//
//  Created by Alexandre on 04/07/2024.
//

import SwiftUI

struct GameIcon: View {
    
    @State var icon: String = ""
    @State var gameTitle: String = ""
    
    var body: some View {
        NavigationLink {
            ScoreView(title: self.gameTitle)
        } label: {
            VStack() {
                Image(icon)
                    .resizable()
                    .frame(width: 64, height: 64)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Text(gameTitle)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(uiColor: .label))
            }
        }

    }
}

#Preview {
    GameIcon(icon: "card", gameTitle: "Bridge")
}
