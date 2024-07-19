//
//  Misc.swift
//  ScoreMania
//
//  Created by Alexandre Ricard on 18/07/2024.
//

import Foundation

enum PlayerAuthState: String {
    case authenticated = ""
    case unauthenticated = "Please sign in to Game Center to play."
    case authenticating = "Logging in to Game Center ..."
    
    case error = "Error"
    case restricted = "Restricted"
}

struct PastGuess: Identifiable {
    let id = UUID()
    var move: String
    var correct: Bool
}

let maxTimeRamaining = 15
