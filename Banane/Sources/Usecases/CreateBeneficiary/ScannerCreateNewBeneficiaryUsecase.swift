//
//  ScannerCreateNewBeneficiaryUsecase.swift
//  Banane
//
//  Created by Luc on 22/10/2024.
//
//  Template: 7.0

import Foundation

protocol ScannerCreateNewBeneficiaryUsecaseProtocol: Sendable {
    func execute(input: ScannerCreateNewBeneficiaryUsecase.Input) throws -> ScannerCreateNewBeneficiaryUsecase.Result
 }

/// After user confirmation create a newBeneficiary Entity
final class ScannerCreateNewBeneficiaryUsecase: ScannerCreateNewBeneficiaryUsecaseProtocol {
            
    // MARK: - Dependances

    private let repository: RepositoryProtocol
        
    init(repository: RepositoryProtocol? = nil) {
        self.repository = repository ?? Repository()
    }
    
    // MARK: - DTO

    struct Input {
        let iban: String
        let label: String
    }

    struct Result {
        let beneficiary: Beneficiary
    }
    
    // MARK: - Failure
    
    enum Failure: Error, LocalizedError {
        case alreadyExist
        
        var errorDescription: String? {
            switch self {
            case .alreadyExist:
                "Ce bénéficiaire est déjà enregistré dans votre liste."
            }
        }
    }
    
    // MARK: - DataTask
    
    @discardableResult
    func execute(input: ScannerCreateNewBeneficiaryUsecase.Input) throws -> ScannerCreateNewBeneficiaryUsecase.Result {
        let fetchResult = repository.coreDataService.fetch(
            entity: Beneficiary.self,
            predicate: .init(format: "iban == %@", input.iban)
        )
        
        guard fetchResult.isEmpty else {
            throw Failure.alreadyExist
        }
        
        let newBeneficiary = repository.coreDataService.create(entity: Beneficiary.self)
        newBeneficiary.iban = input.iban
        newBeneficiary.label = input.label
        
        repository.coreDataService.save()
        
        return .init(beneficiary: newBeneficiary)
    }
}
