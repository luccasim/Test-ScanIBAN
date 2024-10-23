//
//  ValidIban.swift
//  Banane
//
//  Created by Luc on 22/10/2024.
//

import Foundation

struct ValidIban: Identifiable {
    
    var id: String {
        iban
    }
    
    var lang: String
    var iban: String
}
