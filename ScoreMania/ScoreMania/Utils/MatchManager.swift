//
//  MatchManager.swift
//  ScoreMania
//
//  Created by Alexandre Ricard on 18/07/2024.
//

import Foundation
import GameKit

class MatchManager: NSObject, ObservableObject {
    @Published var inGame = false;
    @Published var isGameOver = false;
    @Published var isWinner = false;
    @Published var isNull = false;
    @Published var authenticationState = PlayerAuthState.authenticating
    
    @Published var currentlyPlaying = false
    @Published var pastGuesses = [PastGuess]()
    
    @Published var timeRemaining = maxTimeRamaining
    @Published var lastDataReceive = -1
    @Published var shapePlaying = ""
    
    @Published var game = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
    
    @Published var canReMatch = true;
    var otherPlayerReMatch = false;
    @Published var localPlayerReMatch = false;
    @Published var playerScore = 0
    
    var leaderboardsID = "mania.games.wons"
    
    var match: GKMatch?
    var otherPlayer: GKPlayer?
    var currentPlayer = GKLocalPlayer.local
    
    var playerUUIDKey = UUID().uuidString
    
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
    
    func authenticatePlayer() {
        GKLocalPlayer.local.authenticateHandler = { [self] vc, e in
            if let viewController = vc {
                rootViewController?.present(viewController, animated: true)
                return
            }
            
            if let error = e {
                authenticationState = .error
                print(error.localizedDescription)
                return
            }
            
            if currentPlayer.isAuthenticated {
                if currentPlayer.isMultiplayerGamingRestricted {
                    authenticationState = .restricted
                } else {
                    authenticationState = .authenticated
                }
            } else {
                authenticationState = .unauthenticated
            }
        }
    }
    
    func startMatchmaking() {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        
        let matchmakingVC = GKMatchmakerViewController(matchRequest: request)
        matchmakingVC?.matchmakerDelegate = self
        
        rootViewController?.present(matchmakingVC!, animated: true)
    }
    
    func startGame(newMatch: GKMatch) {
        match = newMatch
        match?.delegate = self
        otherPlayer = match?.players.first
        
        sendString("began:\(playerUUIDKey)")
        resetGame()
    }
    
    func receivedString(_ message: String) {
        let messageSplit = message.split(separator: ":")
        guard let messagePrefix = messageSplit.first else { return }
        
        let parameter = String(messageSplit.last ?? "")
        
        switch messagePrefix {
            case "began":
                resetGame()
                if playerUUIDKey == parameter {
                    playerUUIDKey = UUID().uuidString
                    sendString("began:\(playerUUIDKey)")
                    break
                }
            
                currentlyPlaying = playerUUIDKey < parameter
            
                if playerUUIDKey < parameter {
                    shapePlaying = "circle"
                } else {
                    shapePlaying = "square"
                }
            
                inGame = true
                break
            case "case":
                let caseSplit = parameter.split(separator: ";")
                guard let caseY = caseSplit.first else { return }
                guard let caseX = caseSplit.last else { return }
            
                game[Int(caseY)!][Int(caseX)!] = shapePlaying == "circle" ? 2 : 1
            
                currentlyPlaying = true
            
                break
            case "win":
                isGameOver = true
            
                break
            case "null":
                isNull = true
        
                break
            case "quit":
                isWinner = true
                canReMatch = false
            
                winGame()
                break
            case "rematch":
                otherPlayerReMatch = true
            
                if (localPlayerReMatch && otherPlayerReMatch) {
                    startGame(newMatch: match!)
                }
            
                break
            case "norematch":
                canReMatch = false;
                
                break
            default:
                break
        }
    }
    
    func resetGame() {
        game = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
        otherPlayerReMatch = false
        localPlayerReMatch = false
        isWinner = false
        isGameOver = false
        isNull = false
        canReMatch = true
        inGame = true
    }
    
    func winGame() {
        isWinner = true
        
        print("Score get to game center : \(self.playerScore)")
        
        self.playerScore += 1
        
        print("Score after win rate : \(self.playerScore)")
        
        GKLeaderboard.submitScore(
            self.playerScore,
            context: 0,
            player: self.currentPlayer,
            leaderboardIDs: [self.leaderboardsID]
        ) { error in
            print("Update score -- \(error)")
        }
        
        reportAchievement(identifier: "mania.achievement.first", percentComplete: 100)
    }
    
    func loadGlobalScore() {
        GKLeaderboard.loadLeaderboards(
            IDs: [self.leaderboardsID]
        ) { leaderboards, _ in
            leaderboards?[0].loadEntries(
                for: [self.currentPlayer],
                timeScope: .allTime)
            { localPlayerEntry, _, error in
                if let error = error {
                    print("Error loading scores: \(error.localizedDescription)")
                } else if let localPlayerEntry = localPlayerEntry {
                    self.playerScore = localPlayerEntry.score
                }
            }
        }
    }
    
    func reportAchievement(identifier: String, percentComplete: Double) {
            GKAchievement.loadAchievements { achievements, error in
                if let error = error {
                    print("Error loading achievements: \(error.localizedDescription)")
                    return
                }

                var achievementAlreadyReported = false
                if let achievements = achievements {
                    for achievement in achievements {
                        if achievement.identifier == identifier && achievement.isCompleted {
                            achievementAlreadyReported = true
                            break
                        }
                    }
                }

                if !achievementAlreadyReported {
                    let achievement = GKAchievement(identifier: identifier)
                    achievement.percentComplete = percentComplete
                    achievement.showsCompletionBanner = true

                    GKAchievement.report([achievement]) { error in
                        if let error = error {
                            print("Error reporting achievement: \(error.localizedDescription)")
                        } else {
                            print("Achievement reported: \(identifier)")
                        }
                    }
                } else {
                    print("Achievement \(identifier) already completed.")
                }
            }
        }
}

extension MatchManager: GKMatchmakerViewControllerDelegate {
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true)
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: any Error) {
        viewController.dismiss(animated: true)
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        viewController.dismiss(animated: true)
        startGame(newMatch: match)
    }
}

extension MatchManager: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, forRecipient recipient: GKPlayer, fromRemotePlayer player: GKPlayer) {
        let content = String(decoding: data, as: UTF8.self)
        
        if content.starts(with: "strData") {
            let message = content.replacing("strData:", with: "")
            receivedString(message)
        } else {
            lastDataReceive = Int(content)!
        }
    }
    
    func sendString(_ message: String) {
        guard let encoded = "strData:\(message)".data(using: .utf8) else {return}
        sendData(encoded, mode: .reliable)
    }
    
    func sendData(_ data: Data, mode: GKMatch.SendDataMode) {
        do {
            try match?.sendData(toAllPlayers: data, with: mode)
        } catch {
            print(error)
        }
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        
    }
}
