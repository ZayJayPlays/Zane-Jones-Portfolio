//
//  Title View.swift
//  Blackjack
//
//  Created by Zane Jones on 8/30/23.
//

import Foundation
import SwiftUI

extension ContentView {
    var titleView: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image("324620960_561097588952952_8658496493131239439_n 1")
                        .resizable()
                        .frame(width: 120, height: 80)
                        .padding(10)
                }
            }
            VStack {
                Text("Blackjack")
                    .font(.title)
                    .fontWeight(.heavy)
                VStack {
                    Button("Play") {
                        currentView = .setGameView
                    }
                    .fontWeight(.heavy)
                    Button("Learn") {
                        currentView = .learnBasicView
                    }
                }
            }
        }
    }
}
