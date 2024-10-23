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
    
    @StateObject private var beneficiaryViewModel = BeneficiaryViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                AddBeneficiaryView()
            }
            .environment(\.managedObjectContext, persistenceController.context)
            .environmentObject(BeneficiaryViewModel())
        }
    }
}

extension CoreDataService {
    static let shared = CoreDataService(dataModelFileName: "Banane")
}
