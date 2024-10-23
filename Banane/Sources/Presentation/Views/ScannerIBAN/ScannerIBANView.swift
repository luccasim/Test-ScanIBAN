//
//  ScannerIBANView.swift
//  Banane
//
//  Created by Luc on 22/10/2024.
//

import SwiftUI

struct ScannerIBANView: View {
    
    @EnvironmentObject private var beneficiaryViewModel: BeneficiaryViewModel
    @Environment(\.dismiss) var dismiss
        
    var body: some View {
        ZStack {
            
            if let cameraSession = beneficiaryViewModel.cameraSession {
                CameraView(captureSession: cameraSession.captureSession) { result in
                    beneficiaryViewModel.analyse(input: result)
                }
            }
            
            ZStack {
                Rectangle()
                    .fill(Color.blue.opacity(0.3))
                
                Rectangle()
                    .frame(height: 50)
                    .cornerRadius(10)
                    .padding()
                    .blendMode(.destinationOut)
                
                VStack {
                    Text("ScannerIBANView.CameraDescription.Text")
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundStyle(Color.white)
                        .bold()
                    
                    Spacer()
                }
            }
            .compositingGroup()
            .accessibilityLabel("ScannerIBANView.CameraDescription.VoiceOver")
        }
        .navigationTitle("ScannerIBANView.Title.Navigation")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $beneficiaryViewModel.scannedIban) { iban in
            ValidationSheetView(iban: iban)
                .presentationDetents([.medium])
        }
        .onDisappear {
            beneficiaryViewModel.userLeaveScannerView()
        }
    }
}

#Preview {
    NavigationStack {
        ScannerIBANView()
            .environmentObject(BeneficiaryViewModel())
    }
}
