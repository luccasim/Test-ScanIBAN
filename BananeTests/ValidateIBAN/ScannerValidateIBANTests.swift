//
//  ScannerValidateIBANTests.swift
//  BananeTests
//
//  Created by Luc on 23/10/2024.
//
//  Template: 7.0

import Testing
@testable import Banane

@Suite("ScannerValidateIBAN")
struct ScannerValidateIBANUsecaseUnitTests {
    
    let sut: ScannerValidateIBANUsecaseProtocol
    
    init() {
        self.sut = ScannerValidateIBANUsecase()
    }
    
    // MARK: - Success
    
    @Test("Given valids IBAN, When no dependencies, Then result has an valid IBAN",
          arguments: ["FR1234567890123456789012345", "DE89370400440532013000"])
    func testValidIBAN(iban: String) async throws {
        // Given
        let input = ScannerValidateIBANUsecase.Input(scannedText: iban)
        
        // When

        // Then
        let result = sut.execute(input: input)
        #expect(result.iban != nil)
    }
    
    @Test("Given random String, When no dependencies, Then result has not valid IBAN",
          arguments: ["Bonjour", "Hello world", "1234", "azerty"])
    func testRandomString(iban: String) async throws {
        // Given
        let input = ScannerValidateIBANUsecase.Input(scannedText: iban)
        
        // When

        // Then
        let result = sut.execute(input: input)
        #expect(result.iban == nil)
    }
}
