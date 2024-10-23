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
            
            HStack {
                NavigationLink {
                    ScannerIBANView()
                } label: {
                    Label("Scanner", systemImage: "camera")
                }
                .buttonStyle(.borderedProminent)
                
                NavigationLink {
                    EmptyView()
                } label: {
                    Label("Importer", systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.borderedProminent)
                .disabled(true)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 30) {
                TextField("FR76 XXXX", text: $beneficiaryViewModel.ibanInput)
                    .onChange(of: beneficiaryViewModel.ibanInput) { newValue in
                        beneficiaryViewModel.analyse(input: newValue)
                    }
                
                TextField("Personnaliser le nom de compte", text: $beneficiaryViewModel.labelInput)
            }
            
            if let error = beneficiaryViewModel.errors {
                Text(error.localizedDescription)
                    .foregroundStyle(Color.red)
                    .bold()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            beneficiaryViewModel.errors = nil
                        }
                    }
            }
            
            Spacer()
            
            Divider()
            
            Button {
                beneficiaryViewModel.userValidBeneficiary()
            } label: {
                Text("Valider")
                    .frame(width: 200)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!beneficiaryViewModel.isValidForNewBeneficiary)

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
    .environmentObject(BeneficiaryViewModel())
}
