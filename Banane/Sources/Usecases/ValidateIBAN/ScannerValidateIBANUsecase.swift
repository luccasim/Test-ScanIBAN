//
//  ScannerValidateIBANUsecase.swift
//  Banane
//
//  Created by Luc on 22/10/2024.
//
//  Template: 7.0

import Foundation

protocol ScannerValidateIBANUsecaseProtocol: Sendable {
    func execute(input: ScannerValidateIBANUsecase.Input) -> ScannerValidateIBANUsecase.Result
 }

/// Analyse la l'input pour matcher avec une regex IBAN
final class ScannerValidateIBANUsecase: ScannerValidateIBANUsecaseProtocol {
    
    // MARK: - DTO

    struct Input {
        var scannedText: String
    }

    struct Result {
        var iban: ValidIban?
    }
    
    // MARK: - Failure
    
    enum Failure: Error {
        
    }
    
    // MARK: - DataTask
    
    @discardableResult
    func execute(input: ScannerValidateIBANUsecase.Input) -> ScannerValidateIBANUsecase.Result {
        
        let supportedIBAN = [
            "FR": "^FR\\d{2}[0-9A-Z]{23}$",
            "DE": "^DE\\d{20}$"
        ]
        
        for elem in supportedIBAN {
            let predicate = NSPredicate(format: "SELF MATCHES %@", elem.value)
            if predicate.evaluate(with: input.scannedText) {
                return .init(iban: .init(lang: elem.key, iban: input.scannedText))
            }
        }

        return .init()
    }
}
