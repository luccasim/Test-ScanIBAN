//
//  BeneficiaryViewModel.swift
//  Banane
//
//  Created by Luc on 22/10/2024.
//

import Foundation

final class BeneficiaryViewModel: ObservableObject {
    
    // MARK: - Published
    
    @Published var scannedIban: ValidIban?
    @Published var ibanInput = ""
    @Published var labelInput = ""
    @Published var errors: Error?
    @Published var isValidIban = false
    
    var isValidForNewBeneficiary: Bool {
        !labelInput.isEmpty && isValidIban
    }
    
    init(scannedIban: ValidIban? = nil) {
        self.scannedIban = scannedIban
    }
    
    // MARK: - Usecases
    
    private let scannerIBANUsecase = ScannerValidateIBANUsecase()
    private let createNewBeneficiaryUsecase = ScannerCreateNewBeneficiaryUsecase()
    
    // MARK: - Triggers
    
    func analyse(input: String) {
        if scannedIban == nil {
            let result = scannerIBANUsecase.execute(input: .init(scannedText: input))
            DispatchQueue.main.async {
                if let iban = result.iban {
                    self.scannedIban = iban
                    self.isValidIban = true
                } else {
                    self.isValidIban = false
                }
            }
        }
    } 
    
    func userConfirmScannedIBAN(scannedIban: ValidIban?) {
        if let scannedIban = scannedIban {
            self.ibanInput = scannedIban.iban
        } else {
            self.isValidIban = false
        }
        self.scannedIban = nil // dismiss sheet
    }
    
    func userValidBeneficiary() {
        do {
            try createNewBeneficiaryUsecase.execute(input: .init(iban: ibanInput, label: labelInput))
        } catch {
            self.errors = error
        }
    }
}
