//
// Lab #3
// Group #4
// Ari Lee and David Deng
// Date: 2025-11-07
//
// CardView.swift
// Presentation of a single memory card (stateless)
//

import SwiftUI

struct CardView: View {
    let card: CardModel
    let size: CGFloat
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            // Card container with conditional background color
            RoundedRectangle(cornerRadius: 12)
                .fill(card.isMatched ? Color.green.opacity(0.75) : Color.white)
                .shadow(radius: 3)
            
            if card.isFaceUp || card.isMatched {
                // Front of card - shows image
                Image(card.imageName)
                    .resizable()
                    .scaledToFit()
                    .padding(size * 0.12)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                // Back of card - shows pumpkin emoji
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.orange.opacity(0.85))
                    .overlay(
                        Text("🎃")
                            .font(.system(size: size * 0.28))
                    )
            }
            
            // Checkmark indicator for matched cards
            if card.isMatched {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: size * 0.16))
                            .foregroundColor(.green)
                            .background(Circle().fill(Color.white).scaleEffect(1.1))
                            .padding(6)
                    }
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: size, maxHeight: size)
        .onTapGesture {
            // Prevent interaction with matched cards
            if !card.isMatched {
                onTap()
            }
        }
        // Pop animation for card reveal
        .scaleEffect(card.isMatched ? 1.0 : (card.isFaceUp ? 1.0 : 0.78))
        .shadow(
            color: .orange.opacity(card.isFaceUp || card.isMatched ? 0 : 0.2),
            radius: card.isFaceUp || card.isMatched ? 3 : 6
        )
        .animation(.interpolatingSpring(stiffness: 120, damping: 6), value: card.isFaceUp)
        
        // Visual indicators for disabled (matched) cards
        .opacity(card.isMatched ? 0.7 : 1.0)
        .grayscale(card.isMatched ? 0.3 : 0.0)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardView(card: CardModel(imageName: "halloween1", isFaceUp: false), size: 100) { }
                .previewLayout(.sizeThatFits)
                .padding()
            CardView(card: CardModel(imageName: "halloween2", isFaceUp: true), size: 100) { }
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
