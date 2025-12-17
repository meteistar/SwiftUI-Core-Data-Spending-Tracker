//
//  AddTransactionForm.swift
//  SwiftUICoreDataSpendingTracker
//
//  Created by Mete İstar on 16.12.2025.
//

import SwiftUI

struct AddTransactionForm: View {
    
    let card: Card
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var name = ""
    @State private var amount = ""
    @State private var date = Date()
    
    @State private var photoData: Data?
    
    @State private var shouldPresentPhotoPicker = false
    
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
                        shouldPresentPhotoPicker.toggle()
                    } label: {
                        Text("Select Photo")
                    }
                    .fullScreenCover(isPresented: $shouldPresentPhotoPicker, content: { PhotoPickerView(photoData: $photoData) })
                    
                    if let data = self.photoData, let image = UIImage.init(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            
                    }
                }
                
            }
            .navigationBarTitle("Add Transaction")
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
    }
    
    struct PhotoPickerView: UIViewControllerRepresentable {
        
        @Binding var photoData: Data?
        
        func makeCoordinator() -> Coordinator {
            return Coordinator(parent: self)
        }
        
        class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
            
            private let parent: PhotoPickerView
            
            init(parent: PhotoPickerView) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
                let image = info[.originalImage] as? UIImage
                let resizedImage = image?.resized(to: .init(width: 500, height: 500))
                let imageData = resizedImage?.jpegData(compressionQuality: 0.5)
                self.parent.photoData = imageData
                
                picker.dismiss(animated: true)
                
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                picker.dismiss(animated: true)
            }
            
        }
        func makeUIViewController(context: Context) -> UIViewController {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = context.coordinator
            return imagePicker
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            
        }
    }
    
    private var cancelButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Cancel")
        }
    }
    
//    extension UIImage {
//        func resized(to newSize: CGSize) -> UIImage {
//            return UIGraphicsImageRenderer(size: newSize).image { _ in
//                let hScale = newSize.height / size.height
//                let vScale = newSize.width / size.width
//                let scale = min(hScale, vScale)
//                let resizeSize = CGSize(width: size.width * scale, height: size.height * scale)
//                var middle = CGPoint.zero
//                if resizeSize.width > newSize.width {
//                    middle.x -= (resizeSize.width - newSize.width) / 2.0
//                }
//                if resizeSize.height > newSize.height {
//                    middle.y -= (resizeSize.height - newSize.height) / 2.0
//                }
//                
//                draw(in: CGRect(origin: middle, size: resizeSize))
//            }
//        }
//    }
    
    private var saveButton: some View {
        Button(action: {
            let context = PersistenceController.shared.container.viewContext
            let transaction = CardTransaction(context: context)
            transaction.name = self.name
            transaction.timestamp = self.date
            transaction.amount = Float(self.amount) ?? 0
            transaction.photoData = self.photoData
            
            transaction.card = self.card
            
            do {
                try context.save()
                presentationMode.wrappedValue.dismiss()
            } catch let customError{
                print("Failed to save transaction: \(customError)")
            }
            
        }) {
            Text("Save")
        }
    }
}

//#Preview {
//    AddTransactionForm()
//}
struct AddTransactionForm_Previews : PreviewProvider {

    static let firstCard: Card? = {
        let context = PersistenceController.preview.container.viewContext
        let request = Card.fetchRequest()
        request.sortDescriptors = [.init(key: "timestamp", ascending: false)]
        return try? context.fetch(request).first
    }()
    
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        if let card = firstCard {
            AddTransactionForm(card: card)
//                .environment(\.managedObjectContext, context)
        }
        
    }
}
