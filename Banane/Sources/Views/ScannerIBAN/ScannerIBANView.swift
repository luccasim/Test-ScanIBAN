//
//  ScannerIBANView.swift
//  Banane
//
//  Created by Luc on 22/10/2024.
//

import SwiftUI

struct ScannerIBANView: View {
    
    @EnvironmentObject private var scannerViewModel: ScannerViewModel
    @Environment(\.dismiss) var dismiss
        
    var body: some View {
        ZStack {
            IBANScannerView()
            
            ZStack {
                Rectangle().fill(Color.blue.opacity(0.3))
                Rectangle()
                    .frame(height: 50)
                    .cornerRadius(10)
                    .padding()
                    .blendMode(.destinationOut)
                
                VStack {
                    Text("Placer votre IBAN dans le cadre pour \nle scanner")
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundStyle(Color.white)
                    Spacer()
                }
            }
            .compositingGroup()
        }
        .navigationTitle("Scanner votre IBAN")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $scannerViewModel.scannedIban) { iban in
            validationSheet(iban: iban)
        }
    }
    
    private func validationSheet(iban: ValidIban) -> some View {
        VStack {
            Text("L'IBAN du bénéficiaire a été scanné")
                .bold()
            
            VStack {
                Text("Pensez à le vérifier avant de valider:")
                Text("\(iban.iban)")
                    .bold()
            }
            VStack {
                Button {
                    scannerViewModel.userConfirmScannedIBAN(scannedIban: iban)
                    dismiss()
                } label: {
                    Text("Valider")
                }
                
                Button {
                    scannerViewModel.userConfirmScannedIBAN(scannedIban: nil)
                } label: {
                    Text("Recommencer")
                }
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    NavigationStack {
        ScannerIBANView()
            .environmentObject(ScannerViewModel())
    }
}
