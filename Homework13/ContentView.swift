//
// Homework #13
// David Deng
// Date: 2025-11-77
//
// ContentView.swift
// Main view for memory game interface (MVVM)
// Based on Lab 3 by Ari Lee & David Deng
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = MemoryGameViewModel()
    
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        ZStack {
            // Background image
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.38)
            
            VStack(spacing: 12) {
                // Header
                VStack(spacing: 6) {
                    Text("Halloween")
                        .font(.system(size: 50, weight: .heavy, design: .rounded))
                        .foregroundColor(.orange)
                        .shadow(color: .black.opacity(0.6), radius: 3, x: 0, y: 2)
                    Text("Memory Card Game")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 12)
                
                // Progress View
                VStack(spacing: 8) {
                    ProgressView(value: vm.progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                        .scaleEffect(x: 1, y: 1.5, anchor: .center)
                        .padding(.horizontal, 30)
                    
                    HStack {
                        Text("Progress: \(Int(vm.progress * 100))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(vm.cards.filter { $0.isMatched }.count)/\(vm.cards.count) matched")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 30)
                }
                
                // Card grid
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(vm.cards) { card in
                            GeometryReader { geo in
                                CardView(card: card, size: min(geo.size.width, geo.size.height)) {
                                    vm.flipCard(card)
                                }
                                .scaleEffect(card.isMatched ? 1.02 : 1.0)
                                .opacity(card.isMatched ? 0.85 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: card.isMatched)
                            }
                            .aspectRatio(1, contentMode: .fit)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical)
                }
                
                Spacer()
            }
            
            // Game completion overlay
            if vm.gameCompleted {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                VStack(spacing: 20) {
                    Text("Congratulations!")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    Text("All cards matched!")
                        .font(.title2)
                        .foregroundColor(.black.opacity(0.8))
                    
                    Button("Play Again") {
                        withAnimation(.spring()) {
                            vm.setupGame()
                        }
                    }
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 15)
                    .background(Color.orange)
                    .cornerRadius(25)
                    .shadow(radius: 10)
                }
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(radius: 20)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.orange, lineWidth: 3)
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
