//
//  GameOverView.swift
//  ScoreMania
//
//  Created by Alexandre Ricard on 18/07/2024.
//

import SwiftUI

struct GameOverView: View {
    @ObservedObject var matchManager: MatchManager
    
    var body: some View {
        VStack() {
            Spacer ()
            
            Text("Game Over")
                .font(.system(size: 65, weight: .black, design: .rounded))
                .foregroundStyle(Color(uiColor: .systemRed))
            
            Text("Score \(matchManager.score)")
                .font(.system(size: 25, weight: .bold, design: .rounded))
                .foregroundStyle(Color(uiColor: .systemBlue))
             
            
            Spacer()
            
            Button {
                matchManager.isGameOver = false
            } label: {
                Text("Menu")
                    .font(.system(size: 25, weight: .bold, design: .rounded))
            }
            .disabled(matchManager.authenticationState != .authenticated || matchManager.inGame)
            .padding(.vertical, 20)
            .padding(.horizontal, 50)
            .background(
                Capsule(style: .circular)
                    .fill(
                        Color(uiColor: .systemIndigo))
            )
            
            Spacer()

        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .black))
    }
}

#Preview {
    GameOverView(matchManager: MatchManager())
}
