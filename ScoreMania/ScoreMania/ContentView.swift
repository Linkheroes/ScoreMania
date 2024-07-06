//
//  ContentView.swift
//  ScoreMania
//
//  Created by Alexandre on 04/07/2024.
//

import SwiftUI
import GameKit

struct ContentView: View {
    var body: some View {
        TabView() {
            GameSelectionView()
                .tabItem {
                    Label("Games", systemImage: "gamecontroller")
                }
        }.onAppear(perform: {
            authenticateGameCenter()
        })
    }
    
    func authenticateGameCenter() {
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                return
            }
            
            if error != nil {
                return
            }
        }
    }
}

#Preview {
    ContentView()
}
