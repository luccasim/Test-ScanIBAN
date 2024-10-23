//
//  MockRepository.swift
//  BananeTests
//
//  Created by Luc on 23/10/2024.
//

import Foundation
@testable import Banane

final class MockRepository: RepositoryProtocol {
    let coreDataService: CoreDataProtocol = MockCoreData()
}
