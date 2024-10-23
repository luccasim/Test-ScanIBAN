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
            
            Text("AddBeneficiaryView.AddIBANDescription.Text")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            scanFeatureButtons
            
            textFields
            
            Spacer()
            
            Divider()
            
            bottomButtonStack

        }
        .padding()
        .navigationTitle("AddBeneficiaryView.Title.Navigation")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: beneficiaryViewModel.hasError) { newValue in
            if newValue {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
        }
        .alert(isPresented: $beneficiaryViewModel.hasError) {
            Alert(
                title: Text("BananeApp.ErrorTitle.Alert"),
                message: Text(beneficiaryViewModel.errors?.localizedDescription ?? ""),
                dismissButton: .default(Text("BananeApp.ErrorDismiss.Alert")) {
                    beneficiaryViewModel.hasError = false
                }
            )
        }
    }
    
    var textFields: some View {
        VStack(spacing: 20) {
            Group {
                TextField("AddBeneficiaryView.IBANPlaceholder.TextField", text: $beneficiaryViewModel.ibanInput)
                    .onChange(of: beneficiaryViewModel.ibanInput) { newValue in
                        beneficiaryViewModel.analyse(input: newValue)
                    }
                
                
                TextField("AddBeneficiaryView.LabelPlaceholder.TextField", text: $beneficiaryViewModel.labelInput)
            }
            .padding()
            .background(Color.gray.opacity(0.2).cornerRadius(8))
        }
    }
    
    var scanFeatureButtons: some View {
        HStack(spacing: 20) {
            Button {
                beneficiaryViewModel.userOpenScannerView()
            } label: {
                Label("AddBeneficiaryView.Scan.Button", systemImage: "camera")
                    .padding()
            }
            .buttonStyle(SecondaryButtonStyle())
            .navigationDestination(isPresented: $beneficiaryViewModel.isNavigateToScan) {
                ScannerIBANView()
            }
            
            NavigationLink {
                EmptyView()
            } label: {
                Label("AddBeneficiaryView.Import.Button", systemImage: "square.and.arrow.up")
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
                Text("AddBeneficiaryView.Valid.Button")
                    .frame(width: 250)
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(!beneficiaryViewModel.isValidForNewBeneficiary)
            
            Button {
                beneficiaryViewModel.isNavigateToList = true
            } label: {
                Text("AddBeneficiaryView.SeeBeneficiary.Button")
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
