//
//  Core_Data_TestApp.swift
//  Core Data Test
//
//  Created by Michał Cieslik on 9/13/22.
//

import SwiftUI

@main
struct Core_Data_TestApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}