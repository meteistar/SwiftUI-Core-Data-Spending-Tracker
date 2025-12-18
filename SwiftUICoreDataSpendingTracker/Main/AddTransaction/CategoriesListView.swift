//
//  CategoriesListView.swift
//  SwiftUICoreDataSpendingTracker
//
//  Created by Mete İstar on 18.12.2025.
//

import SwiftUI

struct CategoriesListView: View {
    
    @State private var name = ""
    @State private var color = Color.red
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TransactionCategory.timestamp, ascending: false)],
        animation: .default)
    private var categories: FetchedResults<TransactionCategory>
    
    var body: some View {
        Form{
            Section(header: Text("Select a category")) {
                ForEach(categories) { category in
                    HStack{
                        if let data = category.colorData,
                           let uiColor = UIColor.color(from: data) {
                            let color = Color(uiColor)
                            Spacer()
                                .frame(width: 30, height: 10)
                                .background(color)
                        }
                        Text(category.name ?? "")
                        Spacer()
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        viewContext.delete(categories[index])
                    }
                    try? viewContext.save()
                }
            }
            
            Section(header: Text("Select a category")) {
                TextField("name", text: $name)
                ColorPicker("Color", selection: $color)
                
                Button(action: handleCreate) {
                    HStack {
                        Spacer()
                        Text("Create")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(5)
                    
                }.buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private func handleCreate() {
        let context = PersistenceController.shared.container.viewContext
        
        let category = TransactionCategory(context: context)
        
        category.name = self.name
        category.colorData = UIColor(color).encode()
        category.timestamp = Date()
        
        do {
            try context.save()
            self.name = ""
        } catch {
            print("Failed to save category: \(error)")
        }
    }
}

#Preview {
    CategoriesListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
