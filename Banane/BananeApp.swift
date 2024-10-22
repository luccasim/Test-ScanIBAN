//
//  BananeApp.swift
//  Banane
//
//  Created by Luc on 22/10/2024.
//

import SwiftUI

@main
struct BananeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
