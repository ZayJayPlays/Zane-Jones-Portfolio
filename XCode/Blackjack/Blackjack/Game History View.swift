//
//  Game History View.swift
//  Blackjack
//
//  Created by Zane Jones on 8/30/23.
//

import Foundation
import SwiftUI

extension ContentView {
    var gameHistoryView: some View {
        NavigationView {
            List {
                ForEach(gameResults.indices, id: \.self) { index in
                    let result = gameResults[index]
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Round \(index + 1)")
                                .font(.headline)
                            Spacer()
                            Text("\(result.playerValue) - \(result.dealerValue)")
                                .font(.subheadline)
                        }
                        HStack {
                            Text("Best Action:")
                                .font(.subheadline)
                            Spacer()
                            Text(result.bestAction.stringValue)
                                .font(.subheadline)
                        }
                        HStack {
                            Text("Your Action:")
                                .font(.subheadline)
                            Spacer()
                            Text(result.takenAction.stringValue)
                                .font(.subheadline)
                                .foregroundColor(result.correctAction ? .green:.red)
                        }
                    }
                    .padding()
                }
            }
        }
        
        
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button("Return") {
                    currentView = .setGameView
                    currentRound = 0
                    gameResults = []
                }
            }
        }
    }
}
