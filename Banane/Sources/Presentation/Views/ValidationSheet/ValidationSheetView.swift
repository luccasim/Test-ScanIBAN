//
//  ValidationSheetView.swift
//  Banane
//
//  Created by Luc on 23/10/2024.
//

import SwiftUI

struct ValidationSheetView: View {
    
    @EnvironmentObject private var beneficiaryViewModel: BeneficiaryViewModel
    @Environment(\.dismiss) var dismiss
    
    let iban: ValidIban
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("ValidationSheetView.Title.Text")
                .bold()
                .padding(.top, 20)
            
            Spacer()
            
            VStack(spacing: 8) {
                Text("ValidationSheetView.IBANValidationDescription.Text")
                Text("\(iban.iban)")
                    .bold()
            }
            .accessibilityLabel(Text("ValidationSheetView.IBANValidationDescription.VoiceOver:\(iban.iban)"))
            
            Spacer()
            
            VStack(spacing: 10) {
                Button {
                    beneficiaryViewModel.userConfirmScannedIBAN(confirmIBan: iban)
                    dismiss()
                } label: {
                    Text("ValidationSheetView.Valid.Button")
                        .frame(width: 200)
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Button {
                    beneficiaryViewModel.userConfirmScannedIBAN(confirmIBan: nil)
                    dismiss()
                } label: {
                    Text("ValidationSheetView.Retry.Button")
                        .frame(width: 200)

                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding()
        }
        .presentationDetents([.medium])
        .onAppear {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
}

#Preview {
    ValidationSheetView(iban: .init(lang: "FR", iban: "FR23193789"))
        .environmentObject(BeneficiaryViewModel(scannedIban: .init(lang: "FR", iban: "FR23193789")))
}
