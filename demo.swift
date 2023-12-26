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
    print(p.name)
}