//
//  Buttons.swift
//  Banane
//
//  Created by Luc on 23/10/2024.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 50)
            .foregroundStyle(Color.white)
            .background(Color.bfbBlue)
            .clipShape(Capsule())
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 50)
            .foregroundStyle(Color.bfbBlue)
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(Color.bfbBlue)
            )
    }
}
