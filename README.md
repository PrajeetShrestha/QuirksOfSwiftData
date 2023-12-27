# Quirks Of SwiftData

## Overview

This project will showcase all the quirks and gotchas of SwiftData as of iOS 17.2. SwiftData is rapidly evolving and the experiments in this repo might be obsolete in the future, still this might help people researching on SwiftData.
**Feedbacks and pull requests most appreciated.**

## Quirks One

### Models used

``` swift
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
```

While it was claimed in the SwiftData WWDC video that @Observable(ObservableObject/Observable)  objects could be easily swapped with @Model(PeristentModel) objects but that doesn't seem to be the case. In models with relationship if you can't access related object before inserting the object into modelContext.

```swift
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
    
```
