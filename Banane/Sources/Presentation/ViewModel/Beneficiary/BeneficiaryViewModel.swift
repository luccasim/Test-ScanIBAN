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
    @Published var cameraSession: CameraSession?
    @Published var ibanInput = ""
    @Published var labelInput = ""
    @Published var errors: Error?
    @Published var isValidIban = false
    @Published var hasError = false
    
    @Published var isNavigateToScan = false
    @Published var isNavigateToList = false
    
    var isValidForNewBeneficiary: Bool {
        !labelInput.isEmpty && isValidIban
    }
    
    init(scannedIban: ValidIban? = nil) {
        self.scannedIban = scannedIban
        self.errors = SetupCameraUsecase.Failure.unableToSetupCaptureDevice
    }
    
    // MARK: - Usecases
    
    private let scannerIBANUsecase = ScannerValidateIBANUsecase()
    private let createNewBeneficiaryUsecase = ScannerCreateNewBeneficiaryUsecase()
    private let setupCameraSessionUsecase = SetupCameraUsecase()
    
    // MARK: - Triggers
    
    func analyse(input: String) {
        if scannedIban == nil {
            let result = scannerIBANUsecase.execute(input: .init(scannedText: input))
            DispatchQueue.main.async {
                if let iban = result.iban {
                    self.scannedIban = iban
                    self.isValidIban = true
                }
            }
        }
    }
    
    func userOpenScannerView() {
        do {
            let result = try setupCameraSessionUsecase.execute(input: .init())
            self.cameraSession = result.validCaptureSession
            DispatchQueue.global(qos: .userInitiated).async {
                self.cameraSession?.captureSession.startRunning()
            }
        } catch {
            self.errors = errors
            self.hasError = true
        }
        self.isNavigateToScan = true
        self.resetTextField()
    }
    
    func resetTextField() {
        self.ibanInput = ""
        self.labelInput = ""
        self.isValidIban = false
        self.scannedIban = nil
    }
    
    func userLeaveScannerView() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.cameraSession?.captureSession.stopRunning()
        }
        self.cameraSession = nil
    }
    
    func userConfirmScannedIBAN(scannedIban: ValidIban?) {
        if let scannedIban = scannedIban {
            self.ibanInput = scannedIban.iban
            self.isNavigateToScan = false
            self.isValidIban = true
        } else {
            self.isValidIban = false
        }
        self.scannedIban = nil // dismiss sheet
    }
    
    func userValidBeneficiary() {
        do {
            try createNewBeneficiaryUsecase.execute(input: .init(iban: ibanInput, label: labelInput))
            isNavigateToList = true
        } catch {
            self.errors = error
            self.hasError = true
        }
    }
}
