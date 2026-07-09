//
//  SettingsView.swift
//  Escape
//
//  Created by Tatiana6mo on 6/30/26.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @AppStorage("fontSize") var fontSize: String = "Medium"
    @AppStorage("language") var language: String = "English"
    
    // Colors based on mode
    var backgroundColor: Color {
        isDarkMode ? Color.black : Color(red: 0.0, green: 0.6, blue: 0.6)
    }
    
    var accentColor: Color {
        isDarkMode ? Color.purple : Color(red: 0.0, green: 0.6, blue: 0.6)
    }
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                
                Text("Settings")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                // DARK MODE
                HStack {
                    Text("Dark Mode")
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                    Toggle("", isOn: $isDarkMode)
                        .labelsHidden()
                        .tint(.purple)
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                
                // FONT SIZE
                HStack {
                    Text("Font Size")
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                    Picker("Font Size", selection: $fontSize) {
                        Text("Small").tag("Small")
                        Text("Medium").tag("Medium")
                        Text("Large").tag("Large")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(.white)
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                
                // LANGUAGE
                HStack {
                    Text("Language")
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                    Picker("Language", selection: $language) {
                        Text("English").tag("English")
                        Text("Spanish").tag("Spanish")
                        Text("Irish").tag("Irish")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(.white)
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isDarkMode)
    }
}

