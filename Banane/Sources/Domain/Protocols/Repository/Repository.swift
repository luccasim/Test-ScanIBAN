//
//  Repository.swift
//  Banane
//
//  Created by Luc on 22/10/2024.
//

import Foundation

protocol RepositoryProtocol: Sendable {
    var coreDataService: CoreDataProtocol { get }
}

final class Repository: RepositoryProtocol {
    let coreDataService: CoreDataProtocol = CoreDataService.shared
}
