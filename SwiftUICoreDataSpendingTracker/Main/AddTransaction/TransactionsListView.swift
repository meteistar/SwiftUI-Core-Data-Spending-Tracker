//
//  TransactionsListView.swift
//  SwiftUICoreDataSpendingTracker
//
//  Created by Mete İstar on 16.12.2025.
//

import SwiftUI

struct TransactionsListView: View {
    
    let card: Card
    
    init(card: Card) {
        self.card = card
        
        fetchRequest = FetchRequest<CardTransaction>(entity: CardTransaction.entity(), sortDescriptors: [.init(key: "timestamp", ascending: false)], predicate: .init(format: "card == %@", self.card))
    }
    
    @State private var shoudlShowAddTransactionForm = false
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var fetchRequest: FetchRequest<CardTransaction>
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \CardTransaction.timestamp, ascending: false)],
//        animation: .default)
//    private var transactions: FetchedResults<CardTransaction>
    
    var body: some View {
        VStack {
            Text("Get started by adding your first transaction")
            
            Button {
                shoudlShowAddTransactionForm.toggle()
            } label: {
                Text("+ Transcation")
                    .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
                    .background(Color(.label))
                    .foregroundColor(Color(.systemBackground))
                    .font(.headline)
                    .cornerRadius(5)
            }
            .fullScreenCover(isPresented: $shoudlShowAddTransactionForm, content: {
                AddTransactionForm(card: self.card)
            })
            
            ForEach(fetchRequest.wrappedValue) { transaction in
                CardTransactionView(transaction: transaction)
                    
            }
        }
    }
    
    
    
}

struct CardTransactionView: View {
    
    let transaction: CardTransaction
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    @State var shouldPresentActionSheet = false
    
    private func handleDelete() {
        withAnimation {
            do {
                let context = PersistenceController.shared.container.viewContext
                
                context.delete(transaction)
                
                try context.save()
            } catch {
                print("Failed to delete transaction")
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(transaction.name ?? "")
                        .font(.headline)
                    if let date = transaction.timestamp as Date? {
                        Text(dateFormatter.string(from: date))
                    }
                    
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Button {
                        shouldPresentActionSheet.toggle()
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 24))
                    }.padding(EdgeInsets(top: 6, leading: 8, bottom: 4, trailing: 0))
                        .actionSheet(isPresented: $shouldPresentActionSheet) {
                            .init(title: Text(transaction.name ?? ""), message: nil, buttons: [
                                .destructive(Text("Delete"), action:
                                    handleDelete
                                ),
                                .cancel()
                            ])
                        }
                    Text(String(format:"$%.2f" ,transaction.amount ))
                    
                    
                }

                
            }
            if let photoData = transaction.photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            }
            
        }
        .foregroundColor(Color(.label))
        .padding()
        .background(Color.white)
        .cornerRadius(5)
        .shadow(radius: 5)
        .padding()

    }
}
//#Preview {
struct TransactionsListView_Previews : PreviewProvider {

    static let firstCard: Card? = {
        let context = PersistenceController.preview.container.viewContext
        let request = Card.fetchRequest()
        request.sortDescriptors = [.init(key: "timestamp", ascending: false)]
        return try? context.fetch(request).first
    }()
    
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        if let card = firstCard {
            TransactionsListView(card: card)
                .environment(\.managedObjectContext, context)
        }
        
    }
}
