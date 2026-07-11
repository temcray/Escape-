//
//  MainTabView.swift
//  Escape
//
//  Created by Tatiana6mo on 7/8/26.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @AppStorage("fontSize") var fontSize: String = "Medium"
   
    
    var dynamicFont: Font {
        switch fontSize {
        case "Small": return .footnote
        case "Large": return .title3
        default: return .body
        }
    }
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .accentColor(isDarkMode ? .purple : Color(red: 0.0, green: 0.6, blue: 0.6))
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .environment(\.font, dynamicFont)
    }
}
