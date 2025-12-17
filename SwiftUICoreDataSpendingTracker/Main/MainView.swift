//
//  MainView.swift
//  SwiftUICoreDataSpendingTracker
//
//  Created by Mete İstar on 10.12.2025.
//

import SwiftUI

struct MainView: View {
    
    @State private var shouldPresentAddCardForm = false
    
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.timestamp, ascending: false)],
        animation: .default)
    private var cards: FetchedResults<Card>
    
    @State private var cardSelectionIndex = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                if !cards.isEmpty {
                    TabView(selection: $cardSelectionIndex) {
//                        ForEach(0..<cards.count) { i in
                    ForEach(Array(cards.enumerated()), id: \.element.objectID) { index, card in
//                            let card = cards[i]
                            CreditCardView(card: card)
                                .padding(.bottom, 50)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height: 280)
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    
                    if cards.indices.contains(cardSelectionIndex) {
                        let selectedCard = cards[cardSelectionIndex]
                        Text(selectedCard.name ?? "")
                        TransactionsListView(card: selectedCard)
                    }
                        
                    
                    
                    
                } else {
                    emptyPromtMessage
                }
                                
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddCardForm, onDismiss: nil) {
                        AddCardForm()
                    }
            }
            .navigationTitle("Credit Cards")
            .navigationBarItems(leading: HStack{
                addItemButton
                deleteAllButton
            }, trailing: addCardButton)
        }
        
    }
    
    private var emptyPromtMessage: some View {
        VStack {
            Text("You currently have no cards in the system.")
                .padding(.horizontal, 48)
                .padding(.vertical)
                .multilineTextAlignment(.center)
            Button {
                shouldPresentAddCardForm.toggle()
            } label: {
                Text("+ Add your first card")
                    .foregroundColor(Color(.systemBackground))
            }
            .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
            .background(Color(.label))
            .cornerRadius(5)
            
        }.font(.system(size: 22,weight: .semibold))
    }
    private var deleteAllButton: some View {
        Button {
            cards.forEach { card in
                viewContext.delete(card)
            }
            
            do {
                try viewContext.save()
            } catch {
                
            }
        } label: {
            Text("Delete All")
        }

    }
    var addItemButton: some View {
        Button {
            withAnimation {
                let viewContext = PersistenceController.shared.container.viewContext
                let card = Card(context: viewContext)
                card.timestamp = Date()
                

                do {
                    try viewContext.save()
                } catch {
                    
//                    let nsError = error as NSError
//                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        } label: {
            Text("Add Item")
        }

    }
    struct CreditCardView: View {
        
        let card: Card
        
        @State private var shouldShowActionSheet = false
        @State private var shouldShowEditForm: Bool = false
        
        @State var refreshId = UUID()
        
        private func handleDelete() {
            let viewContext = PersistenceController.shared.container.viewContext
            
            viewContext.delete(card)
            
            do {
                try viewContext.save()
            } catch {
                //error handling
            }
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(card.name ?? "")
                        .font(.system(size: 24, weight: .semibold))
                    Spacer()
                    Text("")
                    Button {
                        shouldShowActionSheet.toggle()
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 28, weight: .bold))
                    }
                    .actionSheet(isPresented: $shouldShowActionSheet) {
                        .init(title: Text(self.card.name ?? ""), message: Text("MESSAGE"), buttons: [
                            .default(Text("Edit"), action: {
                                shouldShowEditForm.toggle()
                            }),
                            .destructive(Text("Delete Card"), action:
                                handleDelete),
                            .cancel()
                        ])
                    }
                    

                }
                HStack {
                    Image("visa")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 44)
                    Spacer()
                    Text("Balance: $5,000")
                        .font(.system(size: 18, weight: .semibold))
                }
                Text("1234 1234 1234 1234")
                
                Text("Credit Limit: $50,000")
                
                HStack {
                    Spacer()
                }
            }
            .foregroundColor(.white)
            .padding()
            .background(
                
                VStack {
                    
                    if let colorData = card.color,
                       let uiColor = UIColor.color(from: colorData)
                       {
                        let actualColor = Color(uiColor)
                        LinearGradient(colors: [
                            actualColor.opacity(0.6),
                            actualColor
                        ], startPoint: .center, endPoint: .bottom)
                    } else {
                        Color.purple
                    }
                }
            )
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black.opacity(0.5), lineWidth: 1))
            .cornerRadius(8)
            .shadow(radius: 5)
            .padding(.horizontal)
            .padding(.top, 8)
            
            .fullScreenCover(isPresented: $shouldShowEditForm) {
                AddCardForm(card: self.card)
                
            }
        }
    }
    var addCardButton: some View {
        Button(action: {
            shouldPresentAddCardForm.toggle()
        }, label: {
            Text("+ Card")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold))
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                .background(Color.black)
                .cornerRadius(5)
            
        })
    }
}
#Preview {
    let viewContext = PersistenceController().container.viewContext
    MainView()
        .environment(\.managedObjectContext, viewContext)
}
