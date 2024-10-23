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
            
            HStack(spacing: 20) {
                NavigationLink {
                    ScannerIBANView()
                } label: {
                    Label("Scanner", systemImage: "camera")
                        .padding()
                }
                .buttonStyle(SecondaryButtonStyle())
                
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
            
            VStack(spacing: 20) {
                
                Button {
                    beneficiaryViewModel.userValidBeneficiary()
                } label: {
                    Text("Valider")
                        .frame(width: 250)
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(!beneficiaryViewModel.isValidForNewBeneficiary)
                
                NavigationLink {
                    BeneficiaryListView()
                } label: {
                    Text("Voir la liste des béneficiares")
                        .padding()
                }
                .buttonStyle(SecondaryButtonStyle())
            }
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
