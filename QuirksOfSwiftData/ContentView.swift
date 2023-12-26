//
//  ContentView.swift
//  QuirksOfSwiftData
//
//  Created by Prajeet Shrestha on 26/12/2023.
//

import SwiftUI
import SwiftData


struct Home: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("QUIRKS #1") {
                    QuirkOneContainer()
                }
            }
        }
    }
}

//struct SwiftDataSampleApp: App {
//    
//    @AppStorage("$shouldStoreInMemory") var shouldStoreInMemory = false
//    @AppStorage("$shouldAutoSave") var shouldAutoSave = true
//    static let models:[any PersistentModel.Type] = [
//        Employee.self,
//        GameConfig.self,
//        GameSet.self,
//        GameRound.self,
//        PlayerScore.self,
//        GamePlayer.self,
//        TestGameRound.self,
//        TestPlayer.self
//    ]
//    
//    var body: some Scene {
//        WindowGroup {
//            GameInitialView()
//                
//        }
//        .modelContainer(
//            for: Self.models,
//            inMemory: true,
//            isAutosaveEnabled: shouldAutoSave,
//            isUndoEnabled: false
//        ) { result in
//            switch result {
//            case .success:
//                logger.log("Container created...")
//            case .failure(let error):
//                logger.log("failed to create container \(error.localizedDescription)")
//            }
//        }
//    }
//}


