//
//  SettingsView.swift
//  Escape
//
//  Created by Tatiana6mo on 6/30/26.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @AppStorage("fontSize") var fontSize: String = "Medium"
    @AppStorage("language") var language: String = "English"
    @AppStorage("loggedInUserId") private var loggedInUserId: String = ""
    
    // Colors based on mode
    var backgroundColor: Color {
        isDarkMode ? Color.black : Color("darkMode")
    }
    
    var accentColor: Color {
        isDarkMode ? Color.purple : Color("darkMode")
    }
    
    var body: some View {
        ZStack {
            Color("background")
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
                
              
                Button(action: {
                    logOut()
                }) {
                    Text("Log Out")
                        .font(.headline.bold())
                        .foregroundColor(isDarkMode ? .purple : .white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isDarkMode ? Color.purple.opacity(0.3) : Color.red.opacity(0.8))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isDarkMode ? Color.purple : Color.red, lineWidth: 2)
                        )
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isDarkMode)
    }
    
    func logOut() {
        loggedInUserId = ""
    }
}




