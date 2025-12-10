//
//  AddCardForm.swift
//  SwiftUICoreDataSpendingTracker
//
//  Created by Mete İstar on 10.12.2025.
//

import SwiftUI

struct AddCardForm: View {
    
    @Environment(\.presentationMode) var presentationMode
        
    @State private var name: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Text("Add card form")
                
                TextField("Name", text: $name)
            }
            .navigationTitle("Add Credit Card")
            .navigationBarItems(leading:
                                    Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Cancel")
            }))
        }
    }
}

#Preview {
    AddCardForm()
}
