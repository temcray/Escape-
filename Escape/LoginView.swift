//
//  LoginView.swift
//  Escape
//
//  Created by Tatiana6mo on 6/30/26.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                // background color
                Color(red: 0.0, green: 0.6, blue: 0.6)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    
                    // app name
                    Text("ESCAPE")
                        .font(.system(size: 52, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 80)
                    
                    Spacer()
                    
                    // sign in
                    NavigationLink(destination: MainTabView()) {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.6))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    
                    // create account
                    Button(action: {}) {
                        Text("Create Account")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.6))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    
                    Spacer()
                }
                
                .padding(. horizontal, 30)
            }
        }
    }
}

