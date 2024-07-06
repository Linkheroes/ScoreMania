import SwiftUI

struct RegisterPlayer: View {
    
    @Binding var players: [Players]
    @Binding var show: Bool
    
    @State private var noCorrect: Int = 0
    @State private var error: Bool = false
    @State private var pendingRemovals: Set<UUID> = []
    
    var body: some View {
        VStack {
            HStack {
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
            
            ForEach($players, id: \.id) { $player in
                HStack {
                    TextField("Player name", text: $player.name)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color(uiColor: .systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    if players.count > 1 && !pendingRemovals.contains(player.id) {
                        Button(action: {
                            removePlayer(player: player)
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
                players.append(Players(id: UUID(), name: "", score: 0, color: randomColor()))
            }, label: {
                Text(players.count >= 4 ? "Maximum number of players reached" : "Add player")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(uiColor: .label))
                    .padding(.horizontal)
            })
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color(uiColor: .systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .disabled(players.count >= 4)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .shadow(radius: 10)
        .padding()
        .animation(.bouncy, value: players.count)
        .alert(isPresented: $error, content: {
            Alert(
                title: Text("Error"),
                message: Text("One or more player(s) don't have name!"),
                dismissButton: .default(Text("OK"))
            )
        })
    }
    
    func closeModal() {
        noCorrect = 0
        for player in players {
            if player.name.isEmpty {
                noCorrect += 1
            }
        }
        if noCorrect == 0 {
            show.toggle()
        } else {
            error.toggle()
        }
    }
    
    func removePlayer(player: Players) {
        pendingRemovals.insert(player.id)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let index = players.firstIndex(where: { $0.id == player.id }) {
                players.remove(at: index)
            }
            pendingRemovals.remove(player.id)
        }
    }
}

#Preview {
    RegisterPlayer(players: .constant([Players(id: UUID(), name: "", score: 0, color: randomColor())]), show: .constant(true))
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
