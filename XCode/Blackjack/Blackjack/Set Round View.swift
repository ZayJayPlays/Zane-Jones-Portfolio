//
//  Set Round View.swift
//  Blackjack
//
//  Created by Zane Jones on 8/30/23.
//

import Foundation
import SwiftUI

extension ContentView {
var setRoundView: some View {
    ZStack{
        VStack {
            HStack {
                Button("Back") {
                    currentView = .titleView
                }
                .padding(.leading, 10)
                .padding(.top, 10)
                Spacer()
            }
            Spacer()
        }
        VStack{
            //Text("Set Rounds:")
            TextField("# of Rounds", value: $totalRounds, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .padding(.all)
            Button("Start") {
                if totalRounds > 0 {
                    startGame()
                }
                else {
                    
                }
            }
        }
    }
}

    func startGame() {
        guard totalRounds > 0 else { return }
        currentView = .gameView
        Task {
            await deal()
        }
    }
}
