//
//  ScannerCreateNewBeneficiaryTests.swift
//  BananeTests
//
//  Created by Luc on 23/10/2024.
//
//  Template: 7.0

import Testing
@testable import Banane

@Suite("ScannerCreateNewBeneficiary")
struct ScannerCreateNewBeneficiaryUsecaseUnitTests {
    
    let sut: ScannerCreateNewBeneficiaryUsecaseProtocol
    let repository: MockRepository
    
    init() async throws {
        repository = MockRepository()
        sut = ScannerCreateNewBeneficiaryUsecase(repository: repository)
    }
    
    // MARK: - Success
    
    @Test("Given a new Valid IBAN, when database is reset, Then add the new beneficiary ")
    func testNotOccurencesInContext() async throws {
        // Given
        let input = ScannerCreateNewBeneficiaryUsecase.Input(iban: "FR1234567890123456789012345", label: "Luc")
        
        // When
        repository.coreDataService.clear(entity: Beneficiary.self)

        // Then
        let result = try sut.execute(input: input)
        #expect(result.beneficiary.label == "Luc")
    }
    
    // MARK: - Failures
    
    @Test("Given a new Valid IBAN, when iban is already register, then throw alreadyExist Error")
    func testHasOccurenceInContext() async throws {
        // Given
        let input = ScannerCreateNewBeneficiaryUsecase.Input(iban: "FR1234567890123456789012345", label: "Luc")

        // When
        repository.coreDataService.clear(entity: Beneficiary.self)
        let context = repository.coreDataService.context
        let beneficary = Beneficiary(context: context)
        beneficary.iban = "FR1234567890123456789012345"
        beneficary.label = "Pierre"

        // Then
        await #expect(throws: ScannerCreateNewBeneficiaryUsecase.Failure.alreadyExist) {
            try await sut.execute(input: input)
        }
    }
}

