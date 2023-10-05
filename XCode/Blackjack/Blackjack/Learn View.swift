//
//  Learn View.swift
//  Blackjack
//
//  Created by Zane Jones on 8/31/23.
//

import Foundation
import SwiftUI

extension ContentView {
    var learnView: some View {
        let descriptionText1 = "    Blackjack is a card game where the player tries to draw cards to get as close to 21 as possible without going over."
        let descriptionText2 = """
    All cards have different values that add up to a total value. Suits don't matter.
    Numbers have their values: 2 = 2, 4 = 4.
    Face Cards (Jack, Queens, and Kings) always equal 10
    If you have an Ace, it equals 11 if it doesn't take you over 21, otherwise it's 1, and that can change as you draw cards.
    ex. An ace and a 7 would make the ace equal 11, making the total 18. If you drew a 6, the ace would change to 1, making the total 14.
"""
        let descriptionText3 = """
Hit - When you hit, you take another card. If your total value goes above 21, you lose.

Stand - You stop drawing cards, and the dealer starts playing.

Double - At some casinos, you can Double on your first turn. When you double, you double your initial bet, get hit with one more card, and stand.

Split - At some Casinos, if you have doubles (two 2s, two kings, etc.) You can split your hand into two and play two seperate hands.
"""
        let descriptionText4 = """
    The game begins with you and the dealer getting two cards. You have both of your cards face up, but the dealer only has one face up. You can hit, double or split to get more cards, but if you go over 21, you lose. When you think you're close enough to 21, you stand, and the dealer begins playing. The dealer reveals their unrevealed card. If the dealer's total value is under 16, they draw until they go over. The player always wins ties, and the dealer will lose if they go over 21.
"""
        let descriptionText5 = """
    Basic Strategy is a mathematical method of increasing the odds of winning. (NOT GUARANTEED). You take a look at what you have, what the dealer has, and act appropriately.


"""
        let chartImageString = "TECHOPEDIA-DEALERS-CARD-TABLE"
        
        return Group {
            ZStack {
                VStack {
                    HStack {
                        Button("Back") {
                            currentView = .titleView
                        }
                        Spacer()
                    }
                    .padding(15)
                    
                    GeometryReader { geometry in
                        ScrollView {
                            VStack {
                                Text("What is Blackjack?")
                                    .bold()
                                    .font(.headline)
                                    .padding([.leading, .trailing, .top], 20)
                                Text(descriptionText1)
                                    .padding([.leading, .trailing, .top], 20)
                                Text("How do I get to 21?")
                                    .bold()
                                    .font(.headline)
                                    .padding([.leading, .trailing, .top], 20)
                                Text(descriptionText2)
                                    .padding([.leading, .trailing, .top], 20)
                                Text("What can I do on my turn.")
                                    .bold()
                                    .font(.headline)
                                    .padding([.leading, .trailing, .top], 20)
                                Text(descriptionText3)
                                    .padding([.leading, .trailing, .top], 20)
                                Text("How do I win?")
                                    .bold()
                                    .font(.headline)
                                    .padding([.leading, .trailing, .top], 20)
                                Text(descriptionText4)
                                    .padding([.leading, .trailing, .top], 20)
                                Text("But how do I REALLY win?")
                                    .bold()
                                    .font(.headline)
                                    .padding([.leading, .trailing, .top], 20)
                                Text(descriptionText5)
                                    .padding([.leading, .trailing, .top], 20)
                            }
                                // Add an Image view at the bottom
                                Image(chartImageString) // Replace "your_image_name" with the actual name of your image asset
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width) // Adjust the width to fit the available space
                                    .padding()
                                    .alignmentGuide(.bottom) { d in d[.bottom] }
                            .padding(.bottom, 20) // Add some padding to separate the image from the text
                        }
                        .frame(width: geometry.size.width)
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}
