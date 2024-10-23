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
                    .onChange(of: beneficiaryViewModel.hasError) { errorMessage in
                        if let errorMessage = beneficiaryViewModel.errors?.localizedDescription {
                            localizedError = errorMessage
                            showAlertError = true
                        }
                    }
                    .alert(isPresented: $showAlertError) {
                        Alert(
                            title: Text("BananeApp.ErrorTitle.Alert"),
                            message: Text(localizedError),
                            dismissButton: .default(Text("BananeApp.ErrorDismiss.Alert")) {
                                localizedError = ""
                                beneficiaryViewModel.hasError = false
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
