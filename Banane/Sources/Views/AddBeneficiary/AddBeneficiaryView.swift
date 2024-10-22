//
//  AddBeneficiaryView.swift
//  Banane
//
//  Created by Luc on 22/10/2024.
//

import SwiftUI

struct AddBeneficiaryView: View {
    
    @EnvironmentObject var scannerViewModel: ScannerViewModel
    
    var body: some View {
        VStack(spacing: 40) {
            
            Text("Scannez, importer ou saisissez l'IBAN")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                NavigationLink {
                    IBANScannerView()
                } label: {
                    Label("Scanner", systemImage: "plus")
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 20) {
                TextField("FR76 XXXX", text: $scannerViewModel.ibanInput)
                    .onChange(of: scannerViewModel.ibanInput) { newValue in
                        scannerViewModel.analyse(input: newValue)
                    }
                
                TextField("Personnaliser le nom de compte", text: $scannerViewModel.labelInput)
            }
            
            if let error = scannerViewModel.errors {
                Text(error.localizedDescription)
                    .foregroundStyle(Color.red)
                    .bold()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            scannerViewModel.errors = nil
                        }
                    }
            }
            
            Spacer()
            
            Divider()
            
            Button {
                scannerViewModel.userValidBeneficiary()
            } label: {
                Text("Valider")
            }
            .disabled(!scannerViewModel.isValidForNewBeneficiary)

            NavigationLink {
                BeneficiaryListView()
            } label: {
                Text("Voir la liste des béneficiares")
            }
            .buttonStyle(.plain)
        }
        .padding()
        .navigationTitle("Ajouter un bénéficiare")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        AddBeneficiaryView()
    }
    .environment(\.managedObjectContext, CoreDataService.shared.context)
    .environmentObject(ScannerViewModel())
}
