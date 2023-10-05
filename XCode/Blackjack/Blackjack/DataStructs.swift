//
//  Deck.swift
//  Blackjack
//
//  Created by Zane Jones on 7/20/23.
//

import Foundation

struct Deck: Codable {
    var success: Bool
    var deck_id: String
    var shuffled: Bool
    var remaining: Int
    var cards: [Card]?
}

struct Card: Codable, Equatable, Hashable, Identifiable {
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.code == rhs.code
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
    
    let code: String
    let image: String
    let images: Images
    let value: String
    let suit: String
    
    var id: String {
        return code
    }
}


struct Images: Codable {
    let svg: String
    let png: String
}

struct DrawResponse: Codable {
    let success: Bool
    let deck_id: String
    let cards: [Card]
    let remaining: Int
}

struct WinAlert: Identifiable {
    var id: String {title}
    var title: String
    var description: String
}

func sortAces(_ card1: Card, _ card2: Card) -> Bool {
    if card1.isAce() && !card2.isAce() {
        return false
    } else if !card1.isAce() && card2.isAce() {
        return true
    } else {
        return card1.value < card2.value
    }
}


extension Array<Card> {
    var totalValue: Int {
        var value = 0
        for card in self {
            switch card.value {
            case "ACE":
                if (value + 11) > 21 {
                    value += 1
                }
                else { value += 11 }
                break
            case "JACK", "QUEEN", "KING": value += 10
            default:
                if let intValue = Int(card.value) {
                    value += intValue
                }
            }
        }
        return value
    }
}

struct Result {
    var playerValue: Int
    var dealerValue: Int
    var didSplit: Bool
    var splitValue: Int
    var bestAction: Actions
    var takenAction: Actions
    var correctAction: Bool {
        bestAction == takenAction
    }
}

extension Card {
    func isAce() -> Bool {
        return value == "A"
    }
}

extension Actions {
    var stringValue: String {
        switch self {
        case .hit: return "Hit"
        case .stand: return "Stand"
        case .double: return "Double"
        case .split: return "Split"
        case .null: return "null"
        }
    }
}

enum PossibleViews {
    case gameView
    case setGameView
    case reviewGameView
    case learnBasicView
    case titleView
}

enum Actions {
    case hit
    case stand
    case double
    case split
    case null
}

enum APIError: Error {
    case apiCallFailed
}


