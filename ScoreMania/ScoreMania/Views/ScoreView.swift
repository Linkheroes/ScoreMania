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
    @State var players: [Players] = [Players(name: "Alexandre", score: 0), Players(name: "Léa", score: 0)]
    
    var body: some View {
        VStack() {
            Carousel(index: self.$selectedIndex, items: self.players, cardPadding: 150, id: \.name, content: { card, cardSize in
                VStack() {
                    Text(card.name)
                    
                    HStack() {
                        Button(action: {
                            players[selectedIndex].score -= 1
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
                            .foregroundStyle(Color(uiColor: .label))
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
            })
            
            HStack() {
                ForEach(0..<self.players.count, id:\.self) { index in
                    if self.selectedIndex == index {
                        Image(systemName: "circle.fill")
                            .foregroundStyle(Color(uiColor: .label))
                    } else {
                        Image(systemName: "circle.fill")
                            .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                    }
                }
            }
            .animation(.bouncy, value: self.selectedIndex)
        }
        .navigationTitle(title)
    }
}

#Preview {
    ScoreView()
}
