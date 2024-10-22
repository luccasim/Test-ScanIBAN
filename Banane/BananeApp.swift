//
//  BananeApp.swift
//  Banane
//
//  Created by Luc on 22/10/2024.
//

import SwiftUI

@main
struct BananeApp: App {
    let persistenceController = CoreDataService.shared
    
    @StateObject private var scannerViewModel = ScannerViewModel()

    var body: some Scene {
        WindowGroup {
            AddBeneficiaryView()
                .environment(\.managedObjectContext, persistenceController.context)
                .environmentObject(ScannerViewModel())
        }
    }
}

extension CoreDataService {
    static let shared = CoreDataService(dataModelFileName: "Banane")
}
