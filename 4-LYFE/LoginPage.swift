import SwiftUI

enum Destination: Hashable {
    case workouts
}

struct LoginPage: View {
    let backgroundColor = Color(red: 51/255, green: 69/255, blue: 127/255)
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showSuccessAlert = false
    @State private var isLoggedIn = false
    
    @State private var navigationPath: [Destination] = []
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 15) {
                    
                    TextField("Email", text: $email)
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    SecureField("Password", text: $password)
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Login") {
                        login()
                    }
                }
                .navigationTitle("Login Page")
                .alert(isPresented: $showSuccessAlert) {
                    Alert(
                        title: Text("Login Successful"),
                        message: Text("You have successfully logged in!"),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .workouts:
                    WorkoutsPage()
                }
            }
        }
    }
    
    func login() {
        guard let url = URL(string: "http://127.0.0.1:8086/user/auth") else {
            print("invalid login")
            return
        }
        
        let loginInfo: [String: String] = [
            "email": email,
            "password": password,
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(loginInfo)
        
        URLSession.shared.dataTask(with: request) { _, response, _ in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200  {
                DispatchQueue.main.async {
                    showSuccessAlert = true
                    navigationPath.append(.workouts)
                }
            }
        }
        .resume()
    }
}

#Preview {
    LoginPage()
}
