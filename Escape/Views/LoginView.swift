//
//  LoginView.swift
//  Escape
//
//  Created by Tatiana6mo on 6/30/26.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("loggedInUserId") private var loggedInUserId: String = ""
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoggedIn = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    @State private var accountCreated = false
    @State private var showCreateAccount = false
    
    
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
                    
                    // Email
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color .white)
                        .cornerRadius(12)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding(.horizontal, 30)
                    
                    
                    // Password
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color .white)
                        .cornerRadius(12)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding(.horizontal, 30)
                    
                    
                    // erorr message
                    if showError {
                        Text("Please enther your email and pasword")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                    
                    
                    // sign in
                    Button(action: performLogin) {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.6))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    
                    // create account
                    //NavigationLink(destination: CreateAccountView()) {
                    Button(action: {showCreateAccount = true}) {
                        Text("Create Account")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.6))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    
                    Spacer()
                    // }
                }
                
                .padding(. horizontal, 30)
            } // zstack
            .navigationDestination(isPresented: $showCreateAccount) {
                CreateAccountView()
            }
        }
    }
    
    
    private func performLogin() {
        // a user with that email should exist
        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate<User> {
                $0.email == email
            }
        )
        
        guard let users = try? modelContext.fetch(descriptor), let user = users.first else {
            errorMessage = "Invalid email"
            print(errorMessage)
            return
        }
        
        // the password should match the user's
        guard user.password == password else {
            errorMessage = "Invalid password"
            print(errorMessage)
            return
        }
        
        // works
        loggedInUserId = user.id.uuidString
    }
}

