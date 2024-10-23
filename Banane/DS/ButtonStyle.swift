//
//  Buttons.swift
//  Banane
//
//  Created by Luc on 23/10/2024.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 50)
            .foregroundStyle(Color.white)
            .background(isEnabled ? Color.bfbBlue : Color.gray)
            .clipShape(Capsule())
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 50)
            .foregroundStyle(isEnabled ? Color.bfbBlue : Color.gray)
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(isEnabled ? Color.bfbBlue : Color.gray)
            )
    }
}
