//
//  Game View.swift
//  Blackjack
//
//  Created by Zane Jones on 8/30/23.
//

import Foundation
import SwiftUI
import URLImage

extension ContentView {
    var blackjackGameView: some View {
        
        ZStack {
            Image("CardTableBackground")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Button("Back") {
                        currentView = .setGameView
                        playerCards = [Card]()
                        dealerCards = [Card]()
                        splitCards = [Card]()
                        playerValue = 0
                        dealerValue = 0
                        splitValue = 0
                        bestAction = .null
                        takenAction = .null
                        winAlert = nil
                        hasDealt = false
                        successfulDeal = false
                        showAlert = false
                        isDealerStanding = false
                        isPlayerStanding = false
                        isSplitStanding = true
                        gameEnded = false
                        splitHands = false
                        cardSize = [80, 120]
                        deckController.reshuffleDeck(remaining: false)
                        currentRound = 0
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)
                    
                }
                Spacer()
                Text("\(currentRound)/\(totalRounds)")
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 20) {
                dealerCardsView
                    .padding(.top)
                
                if !hasDealt {
                    Text("Loading")
                        .font(.title)
                        .foregroundColor(.white)
                }
                HStack(spacing: 5) {
                    Spacer()
                    playerCardsView
                    if splitHands {
                        splitCardsView
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
            .onAppear {
                if !hasDeck {
                    hasDeck = deckController.deck != nil
                    if !hasDealt {
                        loadingTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
                            isLoading = true
                            hasDeck = false
                            currentView = .titleView
                        }
                    }
                }
            }
            .onDisappear {
                loadingTimer?.invalidate()
                loadingTimer = nil
            }
            .onChange(of: hasDealt) { newValue in
                if newValue {
                    isLoading = false
                    isLoadingTimerActive = false
                    loadingTimer?.invalidate()
                    loadingTimer = nil
                }
            }
            .onChange(of: playerCards) { newValue in
                if Date().timeIntervalSince(lastUpdate) > 0.1 {
                    lastUpdate = Date()
                    Task { await updateHasDealt() }
                    updatePlayerValue()
                }
            }
            .onChange(of: dealerCards) { newValue in
                if Date().timeIntervalSince(lastUpdate) > 0.1 {
                    lastUpdate = Date()
                    Task { await updateHasDealt() }
                    updateDealerValue()
                }            }
            .onChange(of: splitCards) {newValue in
                if Date().timeIntervalSince(lastUpdate) > 0.1 {
                    lastUpdate = Date()
                    Task { await updateHasDealt() }
                    updateSplitValue()
                }
            }
            .alert(isPresented: $showAlert) {
                if isLoading {
                    return Alert(
                        title: Text("Connection Error"),
                        message: Text("There was a problem connecting to the server."),
                        dismissButton: .default(Text("OK")) {
                            currentView = .titleView
                        }
                    )
                } else if winAlert != nil {
                    return Alert(
                        title: Text(winAlert!.title),
                        message: Text(winAlert!.description),
                        dismissButton: .default(Text("Okay")))
                } else {
                    return Alert(title: Text("Unknown Error"))
                }
            }
        }
    }
    
    @ViewBuilder
    private var dealerCardsView: some View {
        VStack {
            if dealerCards.isEmpty {
                EmptyView()
            } else {
                if totalStand {
                    Text("Total: \(dealerValue)")
                        .foregroundColor(.white)
                }
                HStack(spacing: 0) {
                    Spacer()
                    let cards = totalStand ? dealerCards : [dealerCards.first!]
                    ForEach(cards, id: \.self) { card in
                        CardView(card: card)
                            .frame(width: 80, height: 120)
                            .layoutPriority(1)
                            .padding(.vertical, 10)
                    }
                    if !totalStand {
                        URLImage(URL(string: "https://deckofcardsapi.com/static/img/back.png")!) { proxy in
                            proxy
                                .resizable()
                                .frame(width: 80, height: 112.5)
                                .layoutPriority(1)
                                .padding(.vertical, 10)
                        }
                    }
                    Spacer()
                }
            }
        }
    }
    
    private var playerCardsView: some View {
        VStack {
            HStack(spacing: 0) {
                ForEach(playerCards) { card in
                    CardView(card: card)
                        .frame(width: CGFloat(cardSize[0]), height: CGFloat(cardSize[1]))
                        .layoutPriority(1)
                        .padding(.vertical, 10)
                }
            }
            if hasDealt {
                buttonView
                Text("Total \(playerValue)")
                    .foregroundColor(.white)
            }
        }
    }
    
    
    private var splitCardsView: some View {
        VStack {
            HStack(spacing: 0){
                ForEach(splitCards) { card in
                    CardView(card: card)
                        .frame(width: CGFloat(cardSize[0]), height: CGFloat(cardSize[1]))
                        .layoutPriority(1)
                        .padding(.vertical, 10)
                }
            }
            if !isSplitStanding {
                splitButtonView
            }
            Text("Total \(splitValue)")
                .foregroundColor(.white)
        }
    }
    
    private var buttonView: some View {
        VStack(spacing: 10) {
            if gameEnded || (totalStand && isDealerStanding) {
                if currentRound != totalRounds {
                    Button("Restart") {
                        restartGame()
                    }
                } else {
                    Button("End") {
                        restartGame()
                    }
                }
            }
            
            if hasDealt && !isPlayerStanding {
                HStack(spacing: 10) {
                    Button("Hit") {
                        Task {
                            await performHit()
                            if takenAction == .null {takenAction = .hit}
                        }
                    }
                    Button("Stand") {
                        Task {
                            await performStand()
                            if takenAction == .null {takenAction = .stand}
                        }
                    }
                    if isFirstTurn && playerCards[0].value == playerCards[1].value {
                        Button("Split") {
                            performSplit()
                            if takenAction == .null {takenAction = .split}
                        }
                    }
                    if isFirstTurn {
                        Button("Double") {
                            performDouble()
                            if takenAction == .null {takenAction = .double}
                        }
                    }
                }
            }
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 20)
        .background(Color.black.opacity(0.5))
        .cornerRadius(10)
    }
    
    
    private var splitButtonView: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                Button("Hit") {
                    Task {
                        await performSplitHit()
                    }
                }
                Button("Stand") {
                    Task {
                        await performSplitStand()
                    }
                }
            }
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 20)
        .background(Color.black.opacity(0.5))
        .cornerRadius(10)
    }
    
    
    
    func deal() async {
        guard let drawnPlayerCards = await deckController.drawCard(2),
              let drawnDealerCards = await deckController.drawCard(2) else
        { return }
        
        playerCards = drawnPlayerCards
        dealerCards = drawnDealerCards
        
        isFirstTurn = true
        print("Card Size: \(cardSize)")
    }
    
    func updateHasDealt() async {
        guard playerCards.count == 2 && dealerCards.count == 2 && !hasDealt else {return}
        
        if dealerValue != 21 {
            successfulDeal = true
        }
        
        guard successfulDeal && !hasDealt else {  await deal(); return }
        hasDealt = true
        currentRound += 1
        print("Current Round \(currentRound)")
        guard playerCards.count == 2 && dealerCards.count == 2 else { print("Error"); return }
        
        do {
            try await calculateActions()
        } catch {
            print("Error: \(error)")
        }
        updateDealerValue()
        print("Dealer: \(dealerValue)")
    }
    
    func updatePlayerValue() {
        playerCards.sort(by: sortAces)
        playerValue = playerCards.totalValue
        print("Player: \(playerValue)")
        Task {
            evaluateHands()
        }
    }
    
    func updateDealerValue() {
        if dealerCards.count >= 2 {
            dealerCards.sort(by: sortAces)
            dealerValue = dealerCards.totalValue
            if totalStand {
                Task {
                    await continueDealerStand()
                    print("!!! \(dealerValue)")
                }
            }

            evaluateHands()
        }
    }
    
    func updateSplitValue() {
        splitCards.sort(by: sortAces)
        splitValue = splitCards.totalValue
        print("Split: \(splitValue)")
        
        evaluateHands()
        
    }
    
    func performHit() async {
        
        playerCards += await deckController.drawCard(1) ?? []
        isFirstTurn = false
        
    }
    
    func performStand() async {
        isPlayerStanding = true
        guard totalStand else { return }
        await continueDealerStand()
    }
    
    func performSplitHit() async {
        splitCards += await deckController.drawCard(1) ?? []
    }
    
    func performSplitStand() async {
        isSplitStanding = true
        guard totalStand else { return }
        await continueDealerStand()
    }
    
    func performDouble() {
        Task {
            do {
                await performHit()
                try await Task.sleep(nanoseconds: 1) // Introduce a small delay (1 second) to allow the view to update.
                if playerValue < 21 {
                    await performStand()
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func performSplit() {
        Task {
            await performHit()
            splitHands = true
            isFirstTurn = false
            isSplitStanding = false
            splitCards.append(playerCards[0])
            playerCards.remove(at: 0)
            cardSize = [40, 60]
            await performSplitHit()
            updateSplitValue()
        }
    }
    
    func continueDealerStand() async {
        if playerValue > 21 {
            dealerValue = dealerCards.totalValue
            isDealerStanding = true
            evaluateHands()
            return
        }
        
        if dealerValue >= 17 && dealerValue <= 21 {
            isDealerStanding = true
            evaluateHands()
        } else if dealerValue < 17 {
            await hitDealer()
        } else {
            
            winAlert = WinAlert(title: "Chicken Dinner", description: "The dealer went over 21")
            showAlert = true
            gameEnded = true
        }
    }
    
    
    func hitDealer() async {
        guard dealerValue < 17 else {return}
        dealerCards += await deckController.drawCard(1)!
    }
    
    func evaluateHands() {
        
        if !isPlayerStanding {
            if playerValue == 21 {
                dealerValue = dealerCards.totalValue
                winAlert = WinAlert(title: "Blackjack!", description: "You got 21 exactly!")
                isPlayerStanding = true
                if isSplitStanding {
                    gameEnded = true
                    if takenAction == .null {
                        takenAction = .stand
                    }
                }
            } else if playerValue > 21 {
                dealerValue = dealerCards.totalValue
                winAlert = WinAlert(title: "You lose!", description: "You went over 21")
                isPlayerStanding = true
                if isSplitStanding {gameEnded = true}
            } else if playerCards.count >= 5 {
                dealerValue = dealerCards.totalValue
                winAlert = WinAlert(title: "Chicken Dinner", description: "You got five cards.")
                isPlayerStanding = true
                if isSplitStanding {gameEnded = true}
            }
            
            if winAlert != nil {
                showAlert = true
                isPlayerStanding = true
                return
            }
        }
        
        
        if splitHands && !isSplitStanding {
            if splitValue == 21 {
                winAlert = WinAlert(title: "Blackjack!", description: "You got 21 exactly!")
                isSplitStanding = true
                if isPlayerStanding { gameEnded = true }
            } else if splitValue > 21 {
                winAlert = WinAlert(title: "You lose!", description: "You went over 21")
                isSplitStanding = true
                if isPlayerStanding { gameEnded = true }
            } else if splitCards.count >= 5 {
                winAlert = WinAlert(title: "Chicken Dinner", description: "You got five cards.")
                isSplitStanding = true
                if isPlayerStanding { gameEnded = true }
            }
            
            if winAlert != nil {
                showAlert = true
                isSplitStanding = true
                return
            }
        }
        
        
        if isDealerStanding {
            if playerValue <= 21 && playerValue >= dealerValue {
                winAlert = WinAlert(title: "Chicken Dinner", description: "You won, \(playerValue) - \(dealerValue)")
            } else if dealerValue > 21 {
                winAlert = WinAlert(title: "Chicken Dinner", description: "The dealer went over 21")
            } else if dealerValue <= 21 && playerValue < dealerValue {
                winAlert = WinAlert(title: "House Wins", description: "You lost, \(playerValue) - \(dealerValue)")
            }
            
            if splitHands && isSplitStanding {
                if splitValue <= 21 && splitValue >= dealerValue {
                    winAlert = WinAlert(title: "Chicken Dinner", description: "You won, \(splitValue) - \(dealerValue)")
                } else if dealerValue <= 21 && splitValue < dealerValue {
                    winAlert = WinAlert(title: "House Wins", description: "You lost, \(splitValue) - \(dealerValue)")
                }
            }
            
            if winAlert != nil {
                showAlert = true
                gameEnded = true
            }
        }
        
        if (totalStand) { gameEnded = true }
    }
    
    func testDeal() {
        Task {
            let playerCardCodes = ["AC", "AS"] // Card codes for player's cards
            let dealerCardCodes = ["KC", "KS"] // Card codes for dealer's cards
            
            // Construct the base URL for card images
            let imageURLBase = "https://deckofcardsapi.com/static/img/"
            
            // Create the player and dealer card arrays with image URLs
            playerCards = playerCardCodes.map { cardCode in
                let imageURL = "\(imageURLBase)\(cardCode).png"
                return Card(code: cardCode, image: imageURL, images: Images(svg: "", png: ""), value: "", suit: "")
            }
            
            dealerCards = dealerCardCodes.map { cardCode in
                let imageURL = "\(imageURLBase)\(cardCode).png"
                return Card(code: cardCode, image: imageURL, images: Images(svg: "", png: ""), value: "", suit: "")
            }
            
            isFirstTurn = true
        }
    }
    
    func restartGame() {
        gameResults.append(Result(playerValue: self.playerValue, dealerValue: self.dealerValue, didSplit: self.splitHands, splitValue: self.splitValue, bestAction: self.bestAction, takenAction: self.takenAction))
        playerCards = [Card]()
        dealerCards = [Card]()
        splitCards = [Card]()
        playerValue = 0
        dealerValue = 0
        splitValue = 0
        bestAction = .null
        takenAction = .null
        winAlert = nil
        hasDealt = false
        successfulDeal = false
        showAlert = false
        isDealerStanding = false
        isPlayerStanding = false
        isSplitStanding = true
        gameEnded = false
        splitHands = false
        cardSize = [80, 120]
        deckController.reshuffleDeck(remaining: false)
        if currentRound == totalRounds {
            currentView = .reviewGameView
        }
        else {
            Task {
                await deal()
            }
        }
    }
    
    func calculateActions() async throws {
        // Specific Combinations and Values
        if playerValue == 21 {
            setAction(.stand)
            return
        }
        if playerValue >= 17 {
            setAction(.stand)
            return
        }
        if playerValue <= 8 {
            setAction(.hit)
            return
        }
        if playerValue == 11 {
            setAction(.double)
            return
        }
        if (playerCards.contains { $0.value == "ACE" } && playerCards.contains { $0.value == "8" }) {
            setAction(.stand)
            return
        }
        if (playerCards[0].value == "4" && playerCards[1].value == "4") {
            setAction(.hit)
            return
        }
        if (playerCards[0].value == "10" && playerCards[1].value == "10") {
            setAction(.stand)
            return
        }
        if (playerCards[0].value == "ACE" && playerCards[1].value == "ACE") {
            setAction(.split)
            return
        }
        
        while dealerCards.count < 2 {
            try await Task.sleep(nanoseconds: 100) // Adjust the sleep duration as needed
        }
        
        // For Aces
        if playerCards.contains(where: { $0.value == "ACE" }) {
            if playerCards.contains(where: { $0.value == "2" }) || playerCards.contains(where: { $0.value == "3" }) {
                if let dealerValue = Int(dealerCards.first?.value ?? "") {
                    if dealerValue >= 5 && dealerValue <= 6 {
                        setAction(.double)
                    } else {
                        setAction(.hit)
                    }
                } else {
                    print("Error: Unable to parse dealer card value")
                }
            } else if playerCards.contains(where: { $0.value == "4" }) || playerCards.contains(where: { $0.value == "5" }) {
                if let dealerValue = Int(dealerCards.first?.value ?? "") {
                    if dealerValue >= 4 && dealerValue <= 6 {
                        setAction(.double)
                    } else {
                        setAction(.hit)
                    }
                } else {
                    print("Error: Unable to parse dealer card value")
                }
            } else if playerCards.contains(where: { $0.value == "5" }) {
                if let dealerValue = Int(dealerCards.first?.value ?? "") {
                    if dealerValue <= 9 {
                        setAction(.double)
                    } else {
                        setAction(.hit)
                    }
                } else {
                    print("Error: Unable to parse dealer card value")
                }
            } else if playerCards.contains(where: { $0.value == "6" }) {
                if let dealerValue = Int(dealerCards.first?.value ?? "") {
                    if dealerValue >= 4 && dealerValue <= 6 {
                        setAction(.double)
                    } else {
                        setAction(.hit)
                    }
                } else {
                    print("Error: Unable to parse dealer card value")
                }
            } else if playerCards.contains(where: { $0.value == "7" }) {
                if let dealerValue = Int(dealerCards.first?.value ?? "") {
                    if dealerValue <= 7 {
                        setAction(.split)
                    } else {
                        setAction(.hit)
                    }
                } else {
                    print("Error: Unable to parse dealer card value")
                }
            } else if playerCards.contains(where: { $0.value == "9" }) {
                if let dealerValue = Int(dealerCards.first?.value ?? "") {
                    if dealerValue <= 6 || (dealerValue >= 8 && dealerValue <= 9) {
                        setAction(.split)
                    } else {
                        setAction(.stand)
                    }
                } else {
                    print("Error: Unable to parse dealer card value")
                }
            } else {
                print("Error at #1")
            }
        }

        // For Pairs
        else if playerCards[0].value == playerCards[1].value {
            if playerCards.contains(where: { $0.value == "2" }) || playerCards.contains(where: { $0.value == "3" }) {
                if Int(dealerCards[0].value)! >= 4 && Int(dealerCards[0].value)! <= 7 {
                    setAction(.split)
                    return
                } else {
                    setAction(.hit)
                    return
                }
            } else if playerCards.contains(where: { $0.value == "5" }) {
                if Int(dealerCards[0].value)! <= 9 {
                    setAction(.double)
                    return
                } else {
                    setAction(.hit)
                    return
                }
            } else if playerCards.contains(where: { $0.value == "6" }) {
                if Int(dealerCards[0].value)! >= 3 && Int(dealerCards[0].value)! <= 6 {
                    setAction(.double)
                    return
                } else {
                    setAction(.hit)
                    return
                }
            } else if playerCards.contains(where: { $0.value == "7" }) {
                if Int(dealerCards[0].value)! <= 7 {
                    setAction(.split)
                    return
                } else {
                    setAction(.hit)
                    return
                }
            } else {
                print("Error at #2")
            }
        }
        // For Standard
        else if playerCards[0].value != playerCards[1].value && !playerCards.contains(where: { $0.value == "ACE" }) {
            if playerValue >= 13 {
                if let dealerValue = Int(dealerCards.first!.value), dealerValue >= 7 {
                    setAction(.hit)
                    return
                } else {
                    setAction(.stand)
                    return
                }
            } else if playerValue == 12 {
                if let dealerValue = Int(dealerCards.first!.value), dealerValue >= 4 && dealerValue <= 6 {
                    setAction(.stand)
                    return
                } else {
                    setAction(.hit)
                    return
                }
            } else if playerValue == 10 {
                if let dealerValue = Int(dealerCards.first!.value), dealerValue == 10 || dealerValue == 11 {
                    setAction(.hit)
                    return
                } else {
                    setAction(.double)
                    return
                }
            } else if playerValue == 9 {
                if let dealerValue = Int(dealerCards.first!.value), dealerValue >= 3 && dealerValue <= 6 {
                    setAction(.double)
                    return
                } else {
                    setAction(.hit)
                    return
                }
            } else {
                print("Error at #3")
            }
        }
    }
    
    
    func setAction(_ action: Actions) {
        bestAction = action
        print(bestAction)
        
    }
}
