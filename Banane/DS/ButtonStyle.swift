//
//  Buttons.swift
//  Banane
//
//  Created by Luc on 23/10/2024.
//

import Foundation
import SwiftUI

/// Button d'action principal, fill, avec le bleu de BforBank
struct PrimaryButtonStyle: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 50)
            .foregroundStyle(Color.white)
            .background(isEnabled ? Color.bfbBlue : Color.gray.opacity(0.5))
            .clipShape(Capsule())
    }
}

/// Boutton d'action secondaire, stroke avec le blue de BforBank
struct SecondaryButtonStyle: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 50)
            .foregroundStyle(isEnabled ? Color.bfbBlue : Color.gray.opacity(0.5))
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(isEnabled ? Color.bfbBlue : Color.gray.opacity(0.5))
            )
    }
}
