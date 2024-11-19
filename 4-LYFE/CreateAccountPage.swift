import SwiftUI
import Foundation

struct CreateAccountPage: View {
    @Binding var navigationPath: [AppDestination]
    
    let backgroundColor = Color(red: 51/255, green: 69/255, blue: 127/255)
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var role: String = ""
//    @State private var confirmPassword: String = ""
    
    @State private var showSuccessAlert = false
    @State private var isSubmitting = false

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 15) {
                Text("Create My Account")
                    .font(.title)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(10)
                
                TextField("First Name", text: $firstName)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Last Name", text: $lastName)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Email", text: $email)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                SecureField("Password", text: $password)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

//                SecureField("Confirm Password", text: $confirmPassword)
//                    .padding(.horizontal)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Role", text: $role)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: submitButtonTapped) {
                    if isSubmitting {
                        ProgressView()
                    } else {
                        Text("Submit")
                    }
                }
                .disabled(isSubmitting)
                .padding(.vertical, 10)
                .padding(.horizontal, 50)
                .background(isSubmitting ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .font(.system(size: 25))
                .cornerRadius(15)
                .padding(20)
                
//                Button("Go to Login") {
//                    navigationPath.append(.login)
//                    print("navigation path \(navigationPath)")
//                }
            }
        }
        .navigationTitle("Create Account")
        .alert(isPresented: $showSuccessAlert) {
            Alert(
                title: Text("Account Created"),
                message: Text("Your account has been created!"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func submitButtonTapped() {
        Task {
            isSubmitting = true
            print("Submit button tapped. Starting account creation...")
            await createAccount()
            isSubmitting = false
        }
    }
    
    func createAccount() async {
        guard let url = URL(string: "http://127.0.0.1:8086/user") else {
            print("Invalid URL")
            return
        }
        
        let accountData: [String: String] = [
            "first_name": firstName.lowercased(),
            "last_name": lastName.lowercased(),
            "email": email.lowercased(),
            "password": password,
            "role": role.lowercased()
        ]
        
        print("Account data: \(accountData)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(accountData)
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                print("Account creation succeeded with status \(httpResponse.statusCode).")
                
                await MainActor.run {
                    resetForm()
                    navigationPath.append(.login)
                    print("navigation path \(navigationPath)")
                }
            } else {
                await MainActor.run {
                    showSuccessAlert = true
                }
            }
        } catch {
            print("Network error:", error)
            await MainActor.run {
                showSuccessAlert = true
            }
        }
    }
    
    func resetForm() {
        firstName = ""
        lastName = ""
        email = ""
        password = ""
        role = ""
//        confirmPassword = ""
    }
}


#Preview {
    @Previewable @State  var mockNavigationPath: [AppDestination] = []

    return CreateAccountPage(navigationPath: $mockNavigationPath)
}
