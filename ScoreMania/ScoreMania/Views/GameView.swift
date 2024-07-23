//
//  GameView.swift
//  ScoreMania
//
//  Created by Alexandre Ricard on 18/07/2024.
//

import SwiftUI
import AlertToast

struct GameView: View {
    @ObservedObject var matchManager: MatchManager
    @State var guessWhoPlaying = ""
    
    @State var enemyAvatar: UIImage? = UIImage(systemName: "person.circle")
    @State var selfAvatar: UIImage? = UIImage(systemName: "person.circle")
    
    @State var showToast = false;
    
    var body: some View {
        ZStack() {
            GeometryReader { _ in
                VStack() {
                    
                    HStack() {
                        HStack() {
                            Image(uiImage: enemyAvatar!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40)
                                .clipShape(Circle())
                            
                            Text(matchManager.otherPlayer?.displayName ?? "guess")
                                .foregroundStyle(.white)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .background(Color(matchManager.shapePlaying == "circle" ? .systemRed : .systemBlue).opacity(0.2))
                        .shadow(radius: 3.0)
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                        
                        Spacer()
                        
                        HStack() {
                            Text(matchManager.currentPlayer.displayName)
                                .foregroundStyle(.white)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                            
                            Image(uiImage: selfAvatar!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40)
                                .clipShape(Circle())
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .background(Color(matchManager.shapePlaying == "circle" ? .systemBlue : .systemRed).opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                        .shadow(radius: 3.0)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    VStack(spacing: 0) {
                        ForEach(0..<matchManager.game.count) { y in
                            HStack(spacing: 0) {
                                Spacer()
                                
                                ForEach(0..<matchManager.game[y].count) { x in
                                    Button(action: {
                                        if matchManager.game[y][x] == 0 {
                                            matchManager.game[y][x] = matchManager.shapePlaying == "circle" ? 1 : 2
                                            matchManager.sendString("case:\(y);\(x)")
                                            
                                            if checkWin() {
                                                matchManager.sendString("win")
                                                matchManager.winGame()
                                            } else {
                                                if checkIfMoveIsPossible() {
                                                    matchManager.currentlyPlaying = false
                                                } else {
                                                    matchManager.sendString("null")
                                                    matchManager.isNull = true
                                                }
                                            }
                                        }
                                    }, label: {
                                        ZStack() {
                                            if y == 1 && x == 1 {
                                                Rectangle()
                                                    .fill(Color("primary"))
                                                    .frame(width: 96, height: 96)
                                                    .border(Color("secondary"), width: 10)
                                            } else if y == 1 {
                                                Rectangle()
                                                    .fill(Color("primary"))
                                                    .frame(width: 96, height: 96)
                                                    .border(width: 10, edges: [.top, .bottom], color: Color("secondary"))
                                            } else if x == 1 {
                                                Rectangle()
                                                    .fill(Color("primary"))
                                                    .frame(width: 96, height: 96)
                                                    .border(width: 10, edges: [.trailing, .leading], color: Color("secondary"))
                                            } else {
                                                Rectangle()
                                                    .fill(Color("primary"))
                                                    .frame(width: 96, height: 96)
                                            }
                                            
                                            if matchManager.game[y][x] == 1 {
                                                Circle()
                                                    .stroke(.blue, lineWidth: 5).frame(width: 64, height: 64)
                                                
                                            } else if matchManager.game[y][x] == 2 {
                                                Image(systemName: "xmark")
                                                    .resizable()
                                                    .foregroundStyle(.red)
                                                    .frame(width: 64, height: 64)
                                            }
                                        }
                                    })
                                    .disabled(!matchManager.currentlyPlaying || matchManager.game[y][x] != 0)
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    
                    Spacer()
                    
                    
                    
                    HStack() {
                        Button(action: {
                            matchManager.sendString("quit")
                            matchManager.inGame = false
                        }, label: {
                            Image(systemName: "door.left.hand.open")
                                .font(.system(size: 25, weight: .bold, design: .rounded))
                                .foregroundStyle(.red)
                                .padding(.trailing)
                        })
                        
                        Spacer()
                        
                        ZStack() {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("primary"))
                                .shadow(radius: 10)
                            
                            HStack() {
                                Text("game.bottom.text")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)
                                
                                Text("\(matchManager.playerScore)")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)
                            }
                        }
                        
                    }
                    .padding(.horizontal)
                    .frame(height: 40)
                }
                .blur(radius: matchManager.isWinner || matchManager.isGameOver || matchManager.isNull ? 3.0 : 0)
                
            }
            .background(Color("primary"))
            .foregroundStyle(Color(.white))
            .onAppear(perform: {
                loadPhoto()
                matchManager.loadGlobalScore()
            })
            
            VStack() {
                Text("winner")
                    .font(.system(size: 25, weight: .black, design: .rounded))
                
                Text("winner.sentence")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundStyle(Color("label"))
                
                HStack() {
                    Button(action: {
                        matchManager.sendString("norematch")
                        matchManager.localPlayerReMatch = false
                        matchManager.inGame = false
                    }, label: {
                        Text("cancel")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    })
                    .padding(.vertical, 10)
                    .frame(maxWidth: 150)
                    .background(
                        Capsule(style: .circular)
                            .fill(Color(matchManager.shapePlaying == "circle" ? .systemBlue : .systemRed))
                    )
                    
                    Button(action: {
                        matchManager.sendString("rematch")
                        matchManager.localPlayerReMatch = true
                    }, label: {
                        Text("rematch")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    })
                    .disabled(!matchManager.canTReMatch)
                    .padding(.vertical, 10)
                    .frame(maxWidth: 150)
                    .background(
                        Capsule(style: .circular)
                            .fill(Color(matchManager.shapePlaying == "circle" ? .systemRed : .systemBlue))
                    )
                    
                }
            }
            .foregroundStyle(.white)
            .padding()
            .background(Color("primary"))
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
            .opacity(matchManager.isWinner ? 1 : 0)
            .offset(y: matchManager.isWinner ? 0 : 1000)
            .animation(.easeInOut, value: matchManager.isWinner)
            .shadow(radius: 10)
            
            VStack() {
                Text("looser")
                    .font(.system(size: 25, weight: .black, design: .rounded))
                
                Text("looser.sentence")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundStyle(Color("label"))
                
                HStack() {
                    Button(action: {
                        matchManager.sendString("norematch")
                        matchManager.localPlayerReMatch = false
                        matchManager.inGame = false
                    }, label: {
                        Text("cancel")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    })
                    .padding(.vertical, 10)
                    .frame(maxWidth: 150)
                    .background(
                        Capsule(style: .circular)
                            .fill(Color(matchManager.shapePlaying == "circle" ? .systemBlue : .systemRed))
                    )
                    
                    Button(action: {
                        matchManager.sendString("rematch")
                        matchManager.localPlayerReMatch = true
                    }, label: {
                        Text("rematch")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    })
                    .disabled(!matchManager.canTReMatch)
                    .padding(.vertical, 10)
                    .frame(maxWidth: 150)
                    .background(
                        Capsule(style: .circular)
                            .fill(Color(matchManager.shapePlaying == "circle" ? .systemRed : .systemBlue))
                    )
                    
                }
            }
            .foregroundStyle(.white)
            .padding()
            .background(Color("primary"))
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
            .opacity(matchManager.isGameOver ? 1 : 0)
            .offset(y: matchManager.isGameOver ? 0 : 1000)
            .animation(.easeInOut, value: matchManager.isGameOver)
            .shadow(radius: 10)
            
            VStack() {
                Text("null")
                    .font(.system(size: 25, weight: .black, design: .rounded))
                
                Text("null.sentence")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundStyle(Color("label"))
                
                HStack() {
                    Button(action: {
                        matchManager.sendString("norematch")
                        matchManager.localPlayerReMatch = false
                        matchManager.inGame = false
                    }, label: {
                        Text("cancel")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    })
                    .padding(.vertical, 10)
                    .frame(maxWidth: 150)
                    .background(
                        Capsule(style: .circular)
                            .fill(Color(matchManager.shapePlaying == "circle" ? .systemBlue : .systemRed))
                    )
                    
                    Button(action: {
                        matchManager.sendString("rematch")
                        matchManager.localPlayerReMatch = true
                    }, label: {
                        Text("rematch")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    })
                    .disabled(!matchManager.canTReMatch)
                    .padding(.vertical, 10)
                    .frame(maxWidth: 150)
                    .background(
                        Capsule(style: .circular)
                            .fill(Color(matchManager.shapePlaying == "circle" ? .systemRed : .systemBlue))
                    )
                    
                }
            }
            .foregroundStyle(.white)
            .padding()
            .background(Color("primary"))
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
            .opacity(matchManager.isNull ? 1 : 0)
            .offset(y: matchManager.isNull ? 0 : 1000)
            .animation(.easeInOut, value: matchManager.isNull)
            .shadow(radius: 10)
        }
        .toast(isPresenting: self.$showToast){
            AlertToast(type: .regular, title: "player.quit")
        }
        .onReceive(matchManager.$canTReMatch, perform: { value in
            self.showToast = value
        })
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

        return nb > 0
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


extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        edges.map { edge -> Path in
            switch edge {
            case .top: return Path(.init(x: rect.minX, y: rect.minY, width: rect.width, height: width))
            case .bottom: return Path(.init(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
            case .leading: return Path(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))
            case .trailing: return Path(.init(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
            }
        }.reduce(into: Path()) { $0.addPath($1) }
    }
}
