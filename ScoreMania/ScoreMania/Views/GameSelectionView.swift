//
//  GameSelectionView.swift
//  ScoreMania
//
//  Created by Alexandre on 04/07/2024.
//

import SwiftUI
import GameKit

struct GameSelectionView: View {
    
    @State var games = [Games]()
    
    var body: some View {
        NavigationStack() {
            VStack() {
                
                Text("Choose a game to play")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .padding(.bottom)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], content: {
                    ForEach(self.games, id:\.name) { game in
                        GameIcon(icon: game.gameIcon, gameTitle: game.name)
                    }
                })
            }
            .onAppear(perform: {
                if games.isEmpty {
                    self.loadGames()
                }
            })
            .navigationTitle("Games")
        }
    }
    
    func loadGames() {
        games.append(Games(name: "Uno", gameIcon: "uno"))
        games.append(Games(name: "Wazabi", gameIcon: "wazabi"))
        games.append(Games(name: "Bataille", gameIcon: "card"))
        games.append(Games(name: "Présdient", gameIcon: "card"))
        games.append(Games(name: "Monopoly", gameIcon: "monopoly"))
        games.append(Games(name: "Morpion", gameIcon: "morpion"))
    }
}

#Preview {
    GameSelectionView()
}
