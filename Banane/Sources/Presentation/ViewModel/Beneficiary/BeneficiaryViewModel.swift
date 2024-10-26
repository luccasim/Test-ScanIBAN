//
//  BeneficiaryViewModel.swift
//  Banane
//
//  Created by Luc on 22/10/2024.
//

import Foundation

@MainActor
final class BeneficiaryViewModel: ObservableObject {
    
    // MARK: - Published
    
    @Published var scannedIban: ValidIban?
    @Published var cameraSession: CameraSession?
    @Published var ibanInput = ""
    @Published var labelInput = ""
    @Published var isValidIban = false
    
    @Published var isNavigateToScan = false
    @Published var isNavigateToList = false
            
    var isValidForNewBeneficiary: Bool {
        !labelInput.isEmpty && isValidIban
    }
    
    init(scannedIban: ValidIban? = nil) {
        self.scannedIban = scannedIban
    }
    
    // MARK: - Usecases
    
    private let scannerIBANUsecase = ScannerValidateIBANUsecase()
    private let createNewBeneficiaryUsecase = ScannerCreateNewBeneficiaryUsecase()
    private let setupCameraSessionUsecase = SetupCameraUsecase()
    
    // MARK: Private
    
    private func resetTextField() {
        self.ibanInput = ""
        self.labelInput = ""
        self.isValidIban = false
        self.scannedIban = nil
    }
    
    private func startCamera(session: CameraSession?) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let captureSesion = session?.captureSession {
                captureSesion.startRunning()
            }
        }
    }
    
    private func stopCaerma(session: CameraSession?) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let captureSession = session?.captureSession {
                captureSession.stopRunning()
            }
        }
    }
    
    // MARK: - Triggers
    
    func userScan(input: String) {
        guard scannedIban == nil else {
            return
        }
        
        let result = try? scannerIBANUsecase.execute(input: .init(scannedText: input))
        if let iban = result?.iban {
            self.stopCaerma(session: self.cameraSession)
            self.scannedIban = iban
            self.isValidIban = true
        } else {
            self.scannedIban = nil
            self.isValidIban = false
        }
    }
    
    func userTapIban(input: String) {
        if !isNavigateToScan { // évalue l'input que si le scan n'est pas disponible
            self.scannedIban = nil
            userScan(input: input)
        }
    }
    
    func userOpenScannerView() {
        do {
            let result = try setupCameraSessionUsecase.execute(input: .init())
            self.cameraSession = result.validCaptureSession
            self.startCamera(session: self.cameraSession)
        } catch {
            error.alert()
        }
        self.isNavigateToScan = true
        self.resetTextField()
    }
    
    func userLeaveScannerView() {
        self.stopCaerma(session: self.cameraSession)
        self.cameraSession = nil
    }
    
    func userConfirmScannedIBAN(confirmIBan: ValidIban?) {
        if let confirmIBan = confirmIBan {
            self.ibanInput = confirmIBan.iban
        } else {
            self.isValidIban = false
            // Attend la fin de l'animation de la sheet pour relancer le scanner
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.startCamera(session: self.cameraSession)
            }
        }
    }
    
    func userValidBeneficiary() {
        do {
            try createNewBeneficiaryUsecase.execute(input: .init(iban: ibanInput, label: labelInput))
            isNavigateToList = true
        } catch {
            error.alert()
        }
    }
    
    func userLeaveConfirmSheet() {
        if isValidIban {
            self.isNavigateToScan = false
        }
    }
    
    func userLeaveBeneficiaryList() {
        self.resetTextField()
    }
}
