//
//  GameView.swift
//  ScoreMania
//
//  Created by Alexandre Ricard on 18/07/2024.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var matchManager: MatchManager
    @State var guessWhoPlaying = ""
    
    @State var enemyAvatar: UIImage? = UIImage(named: "Icon")
    @State var selfAvatar: UIImage? = UIImage(named: "Icon")
    
    func makeGuess() {
        // TODO: Submit the guess
    }
    
    var body: some View {
        ZStack() {
            GeometryReader { _ in
                VStack() {
                    
                    HStack() {
                        HStack() {
                            Image(uiImage: enemyAvatar!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48)
                                .clipShape(Circle())
                            
                            Text(matchManager.otherPlayer!.displayName)
                                .foregroundStyle(Color(.white))
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .background(Color(uiColor: !matchManager.currentlyPlaying ? matchManager.shapePlaying == "circle" ? .systemBlue : .systemRed : .systemGray4).opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                        
                        Spacer()
                        
                        VStack() {
                            if matchManager.shapePlaying == "circle" {
                                Rectangle()
                                    .stroke(.blue, lineWidth: 3)
                                    .frame(width: 32, height: 32)
                            } else {
                                Circle()
                                    .stroke(.red, lineWidth: 3)
                                    .frame(width: 32, height: 32)
                            }
                        }
                        .frame(width: 48, height: 48)
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .background(Color(uiColor: .systemGray4).opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                    }
                    
                    Spacer()
                    
                    ForEach(0..<matchManager.game.count) { y in
                        HStack() {
                            Spacer()
                            
                            ForEach(0..<matchManager.game[y].count) { x in
                                Button(action: {
                                    if matchManager.game[y][x] == 0 {
                                        matchManager.game[y][x] = matchManager.shapePlaying == "circle" ? 1 : 2
                                        matchManager.sendString("case:\(y);\(x)")
                                        
                                        if checkWin() {
                                            matchManager.sendString("win")
                                            matchManager.winGame()
                                            matchManager.inGame = false
                                        } else {
                                            if checkIfMoveIsPossible() {
                                                matchManager.currentlyPlaying = false
                                            } else {
                                                matchManager.sendString("null")
                                                matchManager.inGame = false
                                            }
                                        }
                                    }
                                }, label: {
                                    ZStack() {
                                        Rectangle()
                                            .fill(.black)
                                            .frame(width: 96, height: 96)
                                            .border(Color.white)
                                        
                                        if matchManager.game[y][x] == 1 {
                                            Circle()
                                                .stroke(.red, lineWidth: 5).frame(width: 64, height: 64)
                                            
                                        } else if matchManager.game[y][x] == 2 {
                                            Rectangle()
                                                .stroke(.blue, lineWidth: 5).frame(width: 64, height: 64)
                                        }
                                    }
                                })
                                .disabled(!matchManager.currentlyPlaying || matchManager.game[y][x] != 0)
                            }
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                    HStack() {
                        HStack() {
                            Image(uiImage: selfAvatar!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48)
                                .clipShape(Circle())
                            
                            Text(matchManager.currentPlayer.displayName)
                                .foregroundStyle(Color(.white))
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .background(Color(uiColor: matchManager.currentlyPlaying ? matchManager.shapePlaying == "circle" ? .systemRed : .systemBlue : .systemGray4).opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                        
                        Spacer()
                        
                        VStack() {
                            if matchManager.shapePlaying == "circle" {
                                Circle()
                                    .stroke(.red, lineWidth: 3)
                                    .frame(width: 32, height: 32)
                            } else {
                                Rectangle()
                                    .stroke(.blue, lineWidth: 3)
                                    .frame(width: 32, height: 32)
                            }
                        }
                        .frame(width: 48, height: 48)
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .background(Color(uiColor: .systemGray4).opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                    }
                }
                
            }
            .background(Color(uiColor: .black))
            .onAppear(perform: {
                loadPhoto()
            })
        }
    }
    
    func checkWin() -> Bool {
        let table = matchManager.game
        let shape = matchManager.shapePlaying == "circle" ? 1 : 2
        
        if table[0][0] == shape && table[0][1] == shape && table[0][2] == shape {
            return true
        } else if table[0][2] == shape && table[1][2] == shape && table[2][2] == shape {
            return true
        } else if table[0][0] == shape && table[1][0] == shape && table[2][0] == shape {
            return true
        } else if table[2][0] == shape && table[2][1] == shape && table[2][2] == shape {
            return true
        } else if table[0][1] == shape && table[1][1] == shape && table[2][1] == shape {
            return true
        } else if table[0][0] == shape && table[1][1] == shape && table[2][2] == shape {
            return true
        } else if table[0][2] == shape && table[1][1] == shape && table[2][0] == shape {
            return true
        }
        
        return false
    }
    
    func checkIfMoveIsPossible() -> Bool {
        let table = matchManager.game
        var nb: Int = 0

        for y in 0..<table.count {
            for x in 0..<table[y].count {
                if table[y][x] == 0 {
                    nb += 1
                }
            }
        }

        return nb == 0
    }
    
    func loadPhoto() {
        matchManager.currentPlayer.loadPhoto(for: .normal) { image, error in
            if let error = error {
                print("Error loading player photo: \(error.localizedDescription)")
                return
            }
            self.selfAvatar = image
        }
        
        matchManager.otherPlayer!.loadPhoto(for: .normal) { image, error in
            if let error = error {
                print("Error loading player photo: \(error.localizedDescription)")
                return
            }
            self.enemyAvatar = image
        }
    }
}

#Preview {
    GameView(matchManager: MatchManager())
}
