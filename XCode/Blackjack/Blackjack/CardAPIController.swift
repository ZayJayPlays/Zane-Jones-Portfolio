//
//  DeckOfCardsController.swift
//  Blackjack
//
//  Created by Zane Jones on 7/20/23.
//

import Foundation

class CardAPIController {
    
    let api = "https://deckofcardsapi.com/api/deck/"
    
    func getShuffledDeck() async -> Deck? {
        
        var request = URLRequest(url: URL(string:"\(api)new/shuffle/?deck_count=6")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        var deck: Deck?
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            deck = try decoder.decode(Deck.self, from: data)
            return deck
        } catch {
            print("Error \(error)")
            return nil
        }
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                print("Error \(error)")
//                return
//            }
//
//            guard let data = data else {
//                print("No data received")
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                deck = try decoder.decode(Deck.self, from: data)
//                return
//            } catch {
//                if let decodingError = error as? DecodingError {
//                    switch decodingError {
//                    case .keyNotFound(let key, _):
//                        print("Missing key: \(key.stringValue)")
//                        // Handle missing key error, provide default values, or skip the assignment
//                    default:
//                        print("Error parsing JSON: \(error)")
//                    }
//                } else {
//                    print("Error parsing JSON: \(error)")
//                }
//                return
//            }
//        }
//        task.resume()
//        return deck
    }
    
    func reshuffleDeck(deckID: String, remaining: Bool) async -> Deck? {
        
        let urlString = "\(api)\(deckID)/shuffle/?remaining=\(remaining)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        var deck: Deck?
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error \(error)")
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                deck = try decoder.decode(Deck.self, from: data)
            } catch {
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .keyNotFound(let key, _):
                        print("Missing key: \(key.stringValue)")
                        // Handle missing key error, provide default values, or skip the assignment
                    default:
                        print("Error parsing JSON: \(error)")
                    }
                } else {
                    print("Error parsing JSON: \(error)")
                }
            }
        }
        task.resume()
        return deck
    }
    
    func drawCard(deckID: String, count: Int) async -> [Card] {
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: "\(api)\(deckID)/draw/?count=\(count)")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        var cards = [Card]()
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            let drawResponse = try decoder.decode(DrawResponse.self, from: data)
            return drawResponse.cards
        } catch {
            print("Error \(error)")
            return [Card]()
        }
    }
    
//    func backOfCardImage()async -> URL {
//        
//    }

}
