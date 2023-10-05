//
//  ContentView.swift
//  Blackjack
//
//  Created by Zane Jones on 7/20/23.
//

import SwiftUI


let APIController = CardAPIController()


struct ContentView: View {
    @StateObject public var deckController = DeckController()
    @State public var currentView: PossibleViews = .titleView
    
    //Set Game View
    @State public var totalRounds = 1
    @State public var currentRound = 0
    @State public var gameStarted = false
    
    //Game View
    @State public var playerCards = [Card]()
    @State public var playerValue = 0
    @State public var dealerCards = [Card]()
    @State public var dealerValue = 0
    @State public var splitCards = [Card]()
    @State public var splitValue = 0
    @State public var splitHands = false
    @State public var hasDeck = false
    @State public var hasDealt = false
    @State public var successfulDeal = false
    @State public var winAlert: WinAlert?
    @State public var isPlayerStanding = false
    @State public var isSplitStanding = true
    var totalStand: Bool {
        return isPlayerStanding && isSplitStanding
    }
    @State public var isDealerStanding = false
    @State public var isFirstTurn = false
    @State public var showAlert = false;
    @State public var gameEnded = false;
    @State public var isLoading = true
    @State public var loadingTimer: Timer?
    @State public var isLoadingTimerActive = false
    
    // Tracking Actions
    @State public var bestAction: Actions = .null
    @State public var takenAction: Actions = .null
    @State public var bestActionArray = [Actions]()
    @State public var takenActionArray = [Actions]()
    
    //History View
    @State public var gameResults = [Result]()
    
    @State public var lastUpdate = Date()
    @State public var cardSize = [80, 120]
    
    
    var body: some View {
        switch currentView {
        case .gameView:
            blackjackGameView
        case .setGameView:
            setRoundView
        case .reviewGameView:
            gameHistoryView
        case .titleView:
            titleView
        case .learnBasicView:
            learnView
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

