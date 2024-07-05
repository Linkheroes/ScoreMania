//
//  model.swift
//  ScoreMania
//
//  Created by Alexandre on 04/07/2024.
//

import Foundation

struct Games: Codable {
    var name: String
    var gameIcon: String
}

struct Players: Codable, Equatable {
    var name: String
    var score: Int
}
