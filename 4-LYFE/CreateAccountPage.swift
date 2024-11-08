import SwiftUI

enum CreateAccountDestination: Hashable {
    case login
}

struct CreateAccountPage: View {
    let backgroundColor = Color(red: 51/255, green: 69/255, blue: 127/255)
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var role: String = ""
    @State private var confirmPassword: String = ""
    @State private var showSuccessAlert = false
    
    @State private var navigationPath: [CreateAccountDestination] = []

    var body: some View {
        NavigationStack(path: $navigationPath) {
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

                    TextField("Role", text: $role)
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Submit") {
                        createAccount()
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 50)
                    .background(Color.blue)
                    .foregroundStyle(Color.white)
                    .font(.system(size: 25))
                    .cornerRadius(15)
                    .padding(20)
                }
            }
            .navigationTitle("Create Account")
            .navigationDestination(for: CreateAccountDestination.self) { destination in
                switch destination {
                case .login:
                    LoginPage()
                }
            }
        }
    }
    
    func createAccount() {
        
        guard let url = URL(string: "http://127.0.0.1:8086/user") else {
            print("Invalid URL")
            return
        }
        
        let accountData: [String: String] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "password": password,
            "role": role
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(accountData)
        
        URLSession.shared.dataTask(with: request) { _, response, _ in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    navigationPath.append(.login)
                }
            } else {
                DispatchQueue.main.async {
                    showSuccessAlert = true                 }
            }
        }
        .resume()
    }
}

#Preview {
    CreateAccountPage()
}
