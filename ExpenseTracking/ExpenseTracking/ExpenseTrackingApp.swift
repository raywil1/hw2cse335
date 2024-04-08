//
//  ExpenseTrackingApp.swift
//  ExpenseTracking
//
//  Created by Rayhan on 4/7/24.
//

import SwiftUI

@main
struct ExpenseTrackingApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(context: persistenceController.container.viewContext)
        }
    }
}
