//
//  DeckController.swift
//  Blackjack
//
//  Created by Zane Jones on 7/26/23.
//

import Foundation

@MainActor
class DeckController: ObservableObject {
    @Published var deck: Deck?
    
    init() {
//        Task{
//            deck = await APIController.getShuffledDeck()
//        }
    }
    
    func drawCard(_ count: Int) async -> [Card]? {
        if deck == nil {
            deck = await APIController.getShuffledDeck()
        }
        if let deckID = deck?.deck_id {
            return await APIController.drawCard(deckID: deckID, count: count)
        } else {
            return nil
            
        }
    }
    func reshuffleDeck(remaining: Bool) {
        Task {
            if let deckID = deck?.deck_id {
                deck = await APIController.reshuffleDeck(deckID: deckID, remaining: remaining)
            }
        }
    }
}
