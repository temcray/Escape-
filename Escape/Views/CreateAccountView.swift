import SwiftUI
import SwiftData

struct CreateAccountView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("loggedInUserId") private var loggedInUserId: String = ""
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var accountCreated = false
    
    var body: some View {
        ZStack {
            Color("oceanTeal")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Text("Join Escape")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding(.top, 60)
                
                Spacer()
                
                // Name
                TextField("Your Name", text: $name)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 30)
                
                // Email
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding(.horizontal, 30)
                
                // Password
                SecureField("Create Password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 30)
                
                // Error
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.yellow)
                        .font(.caption)
                        .padding(.horizontal, 30)
                }
                
                // SUCCES MESSAGE
                if accountCreated {
                    Text("Account created! Please sign in.")
                    .foregroundColor(.yellow)
                    .font(.caption)
                }
                
                // Join button
                Button(action: saveUser) {
                    Text("Join Escape")
                        .font(.headline)
                        .foregroundColor(Color("oceanTeal"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
    }
    
    private func saveUser() {
        // TODO: validation
        if email.isEmpty || password.isEmpty || name.isEmpty {
            // show error
            print("Missing data")
            return
        }
        
        let user = User(fullName: name, email: email, password: password)
        
        do {
            modelContext.insert(user)
            try modelContext.save()
            print("User created")
            
            accountCreated = true
            loggedInUserId = user.id.uuidString
            
        } catch {
            print("Error creating acconut: \(error)")
        }
        
    }
    
}


