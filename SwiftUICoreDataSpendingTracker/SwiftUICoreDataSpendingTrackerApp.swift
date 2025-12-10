//
//  SwiftUICoreDataSpendingTrackerApp.swift
//  SwiftUICoreDataSpendingTracker
//
//  Created by Mete İstar on 10.12.2025.
//

import SwiftUI

@main
struct SwiftUICoreDataSpendingTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
