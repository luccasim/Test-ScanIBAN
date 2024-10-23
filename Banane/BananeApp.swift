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
    @State private var showAlertError = false
    @State private var localizedError = ""

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                AddBeneficiaryView()
                    .onReceive(beneficiaryViewModel.$errors) { errorMessage in
                        if errorMessage != nil {
                            localizedError = errorMessage?.localizedDescription ?? ""
                            showAlertError = true
                        }
                    }
                    .alert(isPresented: $showAlertError) {
                        Alert(
                            title: Text("Erreur"),
                            message: Text(localizedError),
                            dismissButton: .default(Text("OK")) {
                                localizedError = ""
                            }
                        )
                    }
            }
            .environment(\.managedObjectContext, persistenceController.context)
            .environmentObject(BeneficiaryViewModel())
        }
    }
}

extension CoreDataService {
    static let shared = CoreDataService(dataModelFileName: "Banane")
}
