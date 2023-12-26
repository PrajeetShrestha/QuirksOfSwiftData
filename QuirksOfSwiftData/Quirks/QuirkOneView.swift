//
//  Quirk1.swift
//  QuirksOfSwiftData
//
//  Created by Prajeet Shrestha on 26/12/2023.
//

import Foundation
import SwiftData
import SwiftUI

@Model
fileprivate class Player {
    var name: String
    var round: GameRound?
    
    init(_ name: String) {
        self.name = name
    }
}

@Model
fileprivate class GameRound2 {
    var id = UUID()
    var players: [Player]?
    
    // This type of initialization for related objects won't work
    init(id: UUID = UUID(), players: [Player]? = nil) {
        self.id = id
        self.players = players
    }
}

@Model
fileprivate class GameRound {
    var id = UUID()
    var players: [Player]?
    
    init(id: UUID = UUID()) {
        self.id = id
    }
}

fileprivate class DataManager {
    static func thisWontWork(context: ModelContext) {
        let player1 = Player("Player 1")
        let player2 = Player("Player 2")
        let players = [player1, player2]
        
        let round = GameRound()
        round.players = players
            
        // Accessed property of PersistentModel before inserting into context
        for p in round.players ?? [] {
            print(p.name)
        }
    }
    
    /// This won't work because of the way GameRound2 init method is defined. You should not initialized a property that has inverse this way.
    static func thisWontWork2(context: ModelContext) {
        let player1 = Player("Player 1")
        let player2 = Player("Player 2")
        context.insert(player1)
        context.insert(player2)
        let players = [player1, player2]
        
        let round = GameRound2()
        round.players = players
            
        // Accessed property of PersistentModel before inserting into context
        for p in round.players ?? [] {
            print(p.name)
        }
    }
    
    static func thisWillWork(context: ModelContext) {
        let player1 = Player("Player 1")
        let player2 = Player("Player 2")
        let players = [player1, player2]
        
        let round = GameRound()
        round.players = players
        context.insert(round)

        // Accessed property of PersistentModel only after inserting into context
        for p in round.players ?? [] {
            print(p.name)
        }
    }
}

struct QuirkOneContainer: View {
    var body: some View {
        QuirkOneView()
            .modelContainer(for: [GameRound.self, GameRound2.self])
    }
}

struct QuirkOneView: View {
    
    let description = """
On data with relationship,
"""
    @Environment(\.modelContext) var modelContext
    var body: some View {
        List {
            Button("This won't work") {
                DataManager.thisWontWork(context: modelContext)
            }
            .accentColor(.red)
            
            Button("This won't work 2") {
                DataManager.thisWontWork2(context: modelContext)
            }
            .accentColor(.red)
            
            Button("This will work") {
                DataManager.thisWillWork(context: modelContext)
            }.accentColor(.green)
        }
    }
}

#Preview {
    QuirkOneView()
        .modelContainer(previewContainer)
}

@MainActor
fileprivate let previewContainer: ModelContainer = {
    do {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        
        let container = try ModelContainer(
            for: Schema([GameRound.self, Player.self]),
            configurations: configuration
        )
        container.mainContext.autosaveEnabled = true
        let modelContext = container.mainContext
        
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()
