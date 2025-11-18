//
// Lab #3
// Group #4
// Ari Lee and David Deng
// Date: 2025-11-08
//
// CardModel.swift
// Model for memory card data structure
//

import Foundation

struct CardModel: Identifiable, Equatable {
    let id: UUID
    let imageName: String
    var isFaceUp: Bool = false
    var isMatched: Bool = false
    
    init(id: UUID = UUID(), imageName: String, isFaceUp: Bool = false, isMatched: Bool = false) {
        self.id = id
        self.imageName = imageName
        self.isFaceUp = isFaceUp
        self.isMatched = isMatched
    }
}
