//
//  ValidationSheetView.swift
//  Banane
//
//  Created by Luc on 23/10/2024.
//

import SwiftUI

struct ValidationSheetView: View {
    
    
    @EnvironmentObject private var scannerViewModel: ScannerViewModel
    @Environment(\.dismiss) var dismiss
    
    let iban: ValidIban
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("L'IBAN du bénéficiaire a été scanné")
                .bold()
                .padding(.top, 20)
            
            Spacer()
            
            VStack(spacing: 8) {
                Text("Pensez à le vérifier avant de valider:")
                Text("\(iban.iban)")
                    .bold()
            }
            
            Spacer()
            
            VStack(spacing: 20) {
                Button {
                    scannerViewModel.userConfirmScannedIBAN(scannedIban: iban)
                    dismiss()
                } label: {
                    Text("Valider")
                        .frame(width: 200)
                }
                .buttonStyle(.borderedProminent)
                
                Button {
                    scannerViewModel.userConfirmScannedIBAN(scannedIban: nil)
                } label: {
                    Text("Recommencer")
                        .frame(width: 200)

                }
                .buttonStyle(.bordered)
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    ValidationSheetView(iban: .init(lang: "FR", iban: "FR23193789"))
        .environmentObject(ScannerViewModel(scannedIban: .init(lang: "FR", iban: "FR23193789")))
}
