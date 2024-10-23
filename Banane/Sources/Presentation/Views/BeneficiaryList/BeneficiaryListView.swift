//
//  BeneficiaryListView.swift
//  Banane
//
//  Created by Luc on 22/10/2024.
//

import SwiftUI

struct BeneficiaryListView: View {
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.label)])
    var beneficiary: FetchedResults<Beneficiary>
    
    var body: some View {
        VStack {
            if !beneficiary.isEmpty {
                Text("BeneficiaryListView.AllBeneficiary.Text")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityHidden(true)
                    .padding(20)
                
                ScrollView(showsIndicators: false) {
                    ForEach(beneficiary, id: \.self.iban) { beneficiary in
                        if let iban = beneficiary.iban, let name = beneficiary.label {
                            VStack {
                                Group {
                                    Label {
                                        Text("\(name)")
                                    } icon: {
                                        Image(systemName: "person.circle")
                                    }
                                    Text("\(iban)")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                            .padding()
                        }
                    }
                }
            } else {
                VStack {
                    Spacer()
                    Text("BeneficiaryListView.EmptyBeneficiary.Text")
                    Spacer()
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("BeneficiaryListView.Title.Navigation")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        BeneficiaryListView()
    }
    .environment(\.managedObjectContext, CoreDataService.shared.context)
}
