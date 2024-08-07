//
//  ContentView.swift
//  ScoreMania
//
//  Created by Alexandre Ricard on 18/07/2024.
//

import SwiftUI
import GameKit

struct ContentView: View {
    
    @ObservedObject var matchManager = MatchManager()
    
    var body: some View {
        ZStack() {
            if matchManager.inGame {
                GameView(matchManager: matchManager)
            } else {
                MenuView(matchManager: matchManager)
            }
        }
        .onAppear(perform: {
            matchManager.authenticatePlayer()
        })
    }
}

#Preview {
    ContentView()
}
