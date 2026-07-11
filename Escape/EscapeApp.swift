//
//  EscapeApp.swift
//  Escape
//
//  Created by Tatiana6mo on 6/30/26.
//

import SwiftUI
import SwiftData

@main
struct EscapeApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Song.self,
            User.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @AppStorage("loggedInUserId") private var loggedInUserId: String = ""
    @AppStorage("isDarkMode") var isDarkMode: Bool = false

    var body: some Scene {
        WindowGroup {
            if loggedInUserId.isEmpty {
                LoginView()
            } else {
                MainTabView()
                    .preferredColorScheme(isDarkMode ? .dark : .light)
            }
        }
        
        .modelContainer(sharedModelContainer)
    }
}
