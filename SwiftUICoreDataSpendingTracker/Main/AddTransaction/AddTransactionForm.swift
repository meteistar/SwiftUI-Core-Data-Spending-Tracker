//
//  AddTransactionForm.swift
//  SwiftUICoreDataSpendingTracker
//
//  Created by Mete İstar on 16.12.2025.
//

import SwiftUI

struct AddTransactionForm: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var name = ""
    @State private var amount = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: Text("Information")) {
                    TextField("Name", text: $name)
                    TextField("Amount", text: $amount)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    
                    NavigationLink(destination: Text("new cat page").navigationTitle("New Title"), label: { Text("Many to many") })
                }
                
                Section(header: Text("Photo/Receipt")){
                    Button{
                        
                    } label: { Text("Select Photo")}}
            }
            .navigationBarTitle("Add Transaction")
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
    }
    
    private var cancelButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Cancel")
        }
    }
    
    private var saveButton: some View {
        Button(action: { }) {
            Text("Save")
        }
    }
}

#Preview {
    AddTransactionForm()
}
