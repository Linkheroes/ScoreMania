//
//  model.swift
//  ScoreMania
//
//  Created by Alexandre on 04/07/2024.
//

import Foundation
import SwiftUI

struct Games: Codable {
    var name: String
    var gameIcon: String
}

struct Players: Equatable, Identifiable {
    var id: UUID
    var name: String
    var score: Int
    var color: Color
}
