//
//  RegisterPlayer.swift
//  ScoreMania
//
//  Created by Alexandre on 05/07/2024.
//

import SwiftUI

struct RegisterPlayer: View {
    
    @Binding var players: [Players]
    @Binding var show: Bool
    
    @State var noCorrect: Int = 0
    @State var error: Bool = false
    
    var body: some View {
        VStack() {
            HStack() {
                Button(action: {}, label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color(uiColor: .label))
                })
                .opacity(0)
                
                Spacer()
                
                Text("Register new players")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                
                Spacer()
                
                Button(action: {
                    closeModal()
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color(uiColor: .label))
                })
                
            }
            .padding(.bottom)
            
            ForEach($players) { $player in
                HStack() {
                    TextField("Player name", text: $player.name)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color(uiColor: .systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    if (self.$players.count > 1) {
                        Button(action: {
                            if let index = self.players.firstIndex(where: { $0.id == player.id }) {
                                self.players.remove(at: index)
                            }
                        }, label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(Color(uiColor: .white))
                                .padding(10)
                                .background(Color(uiColor: .red))
                                .clipShape(Circle())
                        })
                    }
                }
            }
            
            Button(action: {
                self.players.append(Players(id: UUID(), name: "", score: 0, color: randomColor()))
            }, label: {
                Text("Add player")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(uiColor: .label))
                    .padding(.horizontal)
            })
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color(uiColor: .systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))

        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .shadow(radius: 10)
        .padding()
        .animation(.bouncy, value: self.players.count)
        .alert(isPresented: self.$error, content: {
            Alert(
                title: Text("Error"),
                message: Text("One or more player(s) don't have name !"),
                dismissButton: .default(Text("OK"))
            )
        })
    }
    
    func closeModal() {
        noCorrect = 0
        for index in 0..<self.players.count {
            if self.players[index].name.isEmpty {
                noCorrect += 1
            }
        }
        if noCorrect == 0 {
            self.show.toggle()
        } else {
            self.error.toggle()
        }
    }
}

#Preview {
    RegisterPlayer(players: .constant([Players(id: UUID(), name: "", score: 0, color: randomColor())]), show: .constant(true))
}
