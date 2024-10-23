//
//  BeneficiaryListView.swift
//  Banane
//
//  Created by Luc on 22/10/2024.
//

import SwiftUI

struct BeneficiaryListView: View {
    
    @FetchRequest(sortDescriptors: []) var beneficiary: FetchedResults<Beneficiary>
    
    var body: some View {
        VStack {
            if !beneficiary.isEmpty {
                Text("Tous")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityHidden(true)
                
                ForEach(beneficiary, id: \.self.iban) { beneficiary in
                    if let iban = beneficiary.iban {
                        Text(iban)
                    }
                }
            } else {
                VStack {
                    Spacer()
                    Text("Vous n'avez pas de bénéficiaires")
                    Spacer()
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Mes Béneficiaires")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        BeneficiaryListView()
    }
    .environment(\.managedObjectContext, CoreDataService.shared.context)
}
