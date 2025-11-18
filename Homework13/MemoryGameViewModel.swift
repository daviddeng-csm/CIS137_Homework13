//
// Lab #3
// Group #4
// Ari Lee and David Deng
// Date: 2025-11-08
//
// MemoryGameViewModel.swift
// ViewModel for memory game logic
//

import Foundation
import SwiftUI

final class MemoryGameViewModel: ObservableObject {
    @Published private(set) var cards: [CardModel] = []
    @Published private(set) var gameCompleted: Bool = false
    @Published private(set) var progress: Double = 0.0 // NEW: Progress tracking
    @Published var canFlip: Bool = true
    
    private var flippedCardIndices: [Int] = []
    
    init() {
        setupGame()
    }
    
    func setupGame() {
        let allImages = (1...16).map { "halloween\($0)" }
        let selectedImages = Array(allImages.shuffled().prefix(6))
        
        var newCards: [CardModel] = []
        for img in selectedImages {
            newCards.append(CardModel(imageName: img))
            newCards.append(CardModel(imageName: img))
        }
        newCards.shuffle()
        
        DispatchQueue.main.async {
            withAnimation(.easeIn(duration: 0.3)) {
                self.cards = newCards
                self.flippedCardIndices = []
                self.canFlip = true
                self.gameCompleted = false
                self.progress = 0.0 // NEW: Reset progress
            }
        }
    }
    
    func flipCard(_ card: CardModel) {
        guard let index = cards.firstIndex(where: { $0.id == card.id }) else { return }
        guard canFlip, !cards[index].isFaceUp, !cards[index].isMatched else { return }
        
        withAnimation(.easeInOut(duration: 0.33)) {
            cards[index].isFaceUp = true
        }
        flippedCardIndices.append(index)
        
        if flippedCardIndices.count == 2 {
            canFlip = false
            let firstIndex = flippedCardIndices[0]
            let secondIndex = flippedCardIndices[1]
            
            if cards[firstIndex].imageName == cards[secondIndex].imageName {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self.cards[firstIndex].isMatched = true
                        self.cards[secondIndex].isMatched = true
                    }
                    self.updateProgress() // Update progress when cards match
                    self.flippedCardIndices = []
                    self.canFlip = true
                    self.checkGameCompletion()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.easeInOut(duration: 0.33)) {
                        self.cards[firstIndex].isFaceUp = false
                        self.cards[secondIndex].isFaceUp = false
                    }
                    self.flippedCardIndices = []
                    self.canFlip = true
                }
            }
        }
    }
    
    // Calculate and update progress
    private func updateProgress() {
        let matchedCount = cards.filter { $0.isMatched }.count
        let totalCards = cards.count
        progress = Double(matchedCount) / Double(totalCards)
    }
    
    private func checkGameCompletion() {
        if cards.allSatisfy({ $0.isMatched }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring()) {
                    self.gameCompleted = true
                }
            }
        }
    }
}
