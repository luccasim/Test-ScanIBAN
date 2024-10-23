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
            CameraView()
            
            ZStack {
                Rectangle()
                    .fill(Color.blue.opacity(0.3))
                
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
                        .bold()
                    
                    Spacer()
                }
            }
            .compositingGroup()
        }
        .navigationTitle("Scanner votre IBAN")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $scannerViewModel.scannedIban) { iban in
            ValidationSheetView(iban: iban)
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    NavigationStack {
        ScannerIBANView()
            .environmentObject(ScannerViewModel())
    }
}
