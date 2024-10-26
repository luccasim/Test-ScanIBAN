//
//  AlertCoordinator.swift
//  Banane
//
//  Created by Luc on 26/10/2024.
//

import SwiftUI

struct AlertCoordinator<Content:View>: View {
    
    @State private var showAlert = false
    @State private var receivedError: Error?
    
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        content()
            .onReceive(NotificationCenter.default.publisher(for: .init("AlertCoordinator")), perform: { output in
                if let error = output.object as? Error {
                    self.receivedError = error
                    self.showAlert = true
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                }
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("AlertCoordinator.ErrorTitle.Alert"),
                    message: Text(receivedError?.localizedDescription ?? ""),
                    dismissButton: .default(Text("AlertCoordinator.ErrorDismiss.Alert")) {
                        showAlert = false
                        receivedError = nil
                    }
                )
            }
    }
}

extension Error {
    func alert() {
        NotificationCenter.default.post(name: .init("AlertCoordinator"), object: self)
    }
}

#Preview {
    AlertCoordinator() {
        Text("Bonjour")
    }
}
