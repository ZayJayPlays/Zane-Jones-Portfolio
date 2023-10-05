//
//  CardView.swift
//  Blackjack
//
//  Created by Zane Jones on 8/21/23.
//

import SwiftUI

struct CardView: View {
    @State private var card: Card
    @State private var isLoaded = false
    @State private var cardImage: UIImage?
    
    init(card: Card) {
        self.card = card
    }
    
    var body: some View {
        GeometryReader { geometry in
            if let image = cardImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            } else {
                Color.clear
                    .onAppear {
                        Task {
                            await loadImage()
                        }
                    }
            }
        }
    }
    
    private func loadImage() async {
        guard let url = URL(string: card.images.png) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let loadedImage = UIImage(data: data) {
                cardImage = loadedImage
                isLoaded = true
            }
        } catch {
            print("Error loading image: \(error)")
        }
    }
}
