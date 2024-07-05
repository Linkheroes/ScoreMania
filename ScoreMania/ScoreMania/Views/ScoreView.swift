//
//  ScoreView.swift
//  ScoreMania
//
//  Created by Alexandre on 04/07/2024.
//

import SwiftUI

struct ScoreView: View {
    @State var title = ""
    @State var selectedIndex = 0
    @State var players: [Players] = []
    @State var showRegister = true
    
    var body: some View {
        ZStack() {
            VStack() {
                Carousel(index: self.$selectedIndex, items: self.players, cardPadding: 150, id: \.id, content: { card, cardSize in
                    VStack() {
                        
                        Spacer()
                        
                        Text(card.name)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                        
                        Spacer()
                        
                        HStack() {
                            Button(action: {
                                if players[selectedIndex].score > 0 {
                                    players[selectedIndex].score -= 1
                                }
                            }, label: {
                                Text("-")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color(uiColor: .label))
                                    .padding(.horizontal)
                            })
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color(uiColor: .secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                            Text("\(card.score)")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .padding(.horizontal)
                            
                            Button(action: {
                                players[selectedIndex].score += 1
                            }, label: {
                                Text("+")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color(uiColor: .label))
                                    .padding(.horizontal)
                            })
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color(uiColor: .secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }
                    .padding(.bottom)
                    .foregroundStyle(.white)
                    .frame(width: cardSize.width, height: cardSize.height / 2)
                    .background(card.color)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .shadow(radius: 10)
                })
                
                HStack() {
                    ForEach(0..<self.players.count, id:\.self) { index in
                        if self.selectedIndex == index {
                            Image(systemName: "circle.fill")
                                .foregroundStyle(Color(uiColor: .label))
                        } else {
                            Image(systemName: "circle.fill")
                                .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                                .onTapGesture {
                                    self.selectedIndex = index;
                                }
                        }
                    }
                }
                .animation(.bouncy, value: self.selectedIndex)
                .padding(.bottom)
            }
            .blur(radius: self.showRegister ? 3.0 : 0)
            .navigationTitle(title)
            
            RegisterPlayer(players: self.$players, show: self.$showRegister)
                .opacity(showRegister ? 1 : 0)
                .offset(y: self.showRegister ? 0 : 1000)
                .animation(.bouncy, value: self.showRegister)
        }
        .onAppear(perform: {
            self.players.append(Players(id: UUID(), name: "", score: 0, color: randomColor()))
        })
    }
}

#Preview {
    ScoreView()
}

public func randomColor() -> Color
{
    let r = Int.random(in: 1..<8)
    if r == 1{
        return Color(uiColor: .systemRed)
    } else if r == 2 {
        return Color(uiColor: .systemBlue)
    } else if r == 3 {
        return Color(uiColor: .systemPink)
    } else if r == 4 {
        return Color(uiColor: .systemYellow)
    } else if r == 5 {
        return Color(uiColor: .systemOrange)
    } else if r == 6 {
        return Color(uiColor: .systemCyan)
    } else if r == 7 {
        return Color(uiColor: .systemMint)
    } else {
        return Color(uiColor:.systemGray)
    }
}
