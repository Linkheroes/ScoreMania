//
//  ContentView.swift
//  ScoreMania
//
//  Created by Alexandre on 04/07/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView() {
            GameSelectionView()
                .tabItem {
                    Label("Games", systemImage: "gamecontroller")
                }
        }
    }
}

#Preview {
    ContentView()
}
