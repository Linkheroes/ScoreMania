//
//  MenuView.swift
//  ScoreMania
//
//  Created by Alexandre Ricard on 18/07/2024.
//

import SwiftUI

struct MenuView: View {
    @ObservedObject var matchManager: MatchManager
    
    var body: some View {
        VStack() {
            Spacer ()
            
            Text("Mania")
                .font(.system(size: 65, weight: .black, design: .rounded))
            
            Spacer()
            
            Button {
                matchManager.startMatchmaking()
            } label: {
                Text("PLAY")
                    .font(.system(size: 25, weight: .bold, design: .rounded))
            }
            .disabled(matchManager.authenticationState != .authenticated || matchManager.inGame)
            .padding(.vertical, 20)
            .padding(.horizontal, 100)
            .background(
                Capsule(style: .circular)
                    .fill(matchManager.authenticationState != .authenticated || matchManager.inGame ? Color(uiColor: .systemGray2) : Color(uiColor: .systemRed))
            )
            
            Text(matchManager.authenticationState.rawValue)
                .font(.headline.weight(.semibold))
                .foregroundStyle(Color(uiColor: .systemBlue))
                .padding()
            
            Spacer()

        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .black))
    }
}

#Preview {
    MenuView(matchManager: MatchManager())
}
