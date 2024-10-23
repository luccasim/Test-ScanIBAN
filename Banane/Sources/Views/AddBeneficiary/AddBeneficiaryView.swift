//
//  AddBeneficiaryView.swift
//  Banane
//
//  Created by Luc on 22/10/2024.
//

import SwiftUI

struct AddBeneficiaryView: View {
    
    @EnvironmentObject var beneficiaryViewModel: BeneficiaryViewModel
    
    var body: some View {
        VStack(spacing: 40) {
            
            Text("Scannez, importer ou saisissez l'IBAN")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            scanFeatureButtons
            
            textFields
            
            Spacer()
            
            Divider()
            
            bottomButtonStack

        }
        .padding()
        .navigationTitle("Ajouter un bénéficiare")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var textFields: some View {
        VStack(spacing: 20) {
            Group {
                TextField("FR76 XXXX", text: $beneficiaryViewModel.ibanInput)
                    .onChange(of: beneficiaryViewModel.ibanInput) { newValue in
                        beneficiaryViewModel.analyse(input: newValue)
                    }
                
                
                TextField("Personnaliser le nom de compte", text: $beneficiaryViewModel.labelInput)
            }
            .padding()
            .accentColor(Color.white)
            .background(Color.gray.opacity(0.2).cornerRadius(8))
        }
    }
    
    var scanFeatureButtons: some View {
        HStack(spacing: 20) {
            Button {
                beneficiaryViewModel.userOpenScannerView()
            } label: {
                Label("Scanner", systemImage: "camera")
                    .padding()
            }
            .buttonStyle(SecondaryButtonStyle())
            .navigationDestination(isPresented: $beneficiaryViewModel.isNavigateToScan) {
                ScannerIBANView()
            }
            
            NavigationLink {
                EmptyView()
            } label: {
                Label("Importer", systemImage: "square.and.arrow.up")
                    .padding()
            }
            .buttonStyle(SecondaryButtonStyle())
            .disabled(true)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    var bottomButtonStack: some View {
        VStack(spacing: 20) {
            Button {
                beneficiaryViewModel.userValidBeneficiary()
            } label: {
                Text("Valider")
                    .frame(width: 250)
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(!beneficiaryViewModel.isValidForNewBeneficiary)
            
            Button {
                beneficiaryViewModel.isNavigateToList = true
            } label: {
                Text("Voir la liste des béneficiares")
                    .padding()
            }
            .buttonStyle(SecondaryButtonStyle())
        }
        .navigationDestination(isPresented: $beneficiaryViewModel.isNavigateToList) {
            BeneficiaryListView()
        }
    }
}

#Preview {
    NavigationView {
        AddBeneficiaryView()
    }
    .environment(\.managedObjectContext, CoreDataService.shared.context)
    .environmentObject(BeneficiaryViewModel())
}
