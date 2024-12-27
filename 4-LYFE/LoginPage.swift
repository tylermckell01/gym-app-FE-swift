import SwiftUI
import KeychainSwift


struct LoginPage: View {
    @Binding var navigationPath: [AppDestination] 

    let backgroundColor = Color(red: 51/255, green: 69/255, blue: 127/255)

    @State var email: String = ""
    @State var password: String = ""
    @State var showSuccessAlert = false
    @State var showErrorAlert = false
    @State var isSubmitting = false

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 15) {
                Text("Login")
                    .font(.largeTitle)
                    .padding()

                TextField("Email", text: $email)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                SecureField("Password", text: $password)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: login) {
                    if isSubmitting {
                        ProgressView()
                    } else {
                        Text("Login")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                Button("go to homepage") {
                    navigationPath.append(.homePage)
                }
                .disabled(isSubmitting)
                .padding(.horizontal)
            }
            .padding()
            .alert(isPresented: $showSuccessAlert) {
                Alert(
                    title: Text("Login Successful"),
                    message: Text("Welcome back!"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Login Failed"),
                    message: Text("Invalid email or password. Please try again."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationTitle("Login Page")
    }

    func login() {
        guard let url = URL(string: "http://127.0.0.1:8086/user/auth") else {
            print("Invalid login URL")
            return
        }

        isSubmitting = true

        let loginInfo: [String: String] = [
            "email": email.lowercased(),
            "password": password,
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(loginInfo)

        URLSession.shared.dataTask(with: request) { data, response, _ in
            DispatchQueue.main.async {
                isSubmitting = false
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let authInfo = json["auth_info"] as? [String: Any],
                       let token = authInfo["auth_token"] as? String,
                       let user = authInfo["user"] as? [String: Any],
                       let userId = user["user_id"] as? String
                    {
                        
                        let keychain = KeychainSwift()
                        keychain.set(token, forKey: "authToken")
                        keychain.set(userId, forKey: "userId")
                        if let firstName = user["first_name"] as? String {
                            keychain.set(firstName, forKey: "firstName")
                            print(user["first_name"]!)
                            print(firstName)
                        }


                        
                        DispatchQueue.main.async {
                            showSuccessAlert = true
                            navigationPath.append(.homePage)
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            } else {
                print("HTTP error or no data")
                DispatchQueue.main.async {
                    showErrorAlert = true
                }
            }
        }
        .resume()
    }
}

#Preview {
    @Previewable @State var mockNavigationPath: [AppDestination] = []

    return LoginPage(navigationPath: $mockNavigationPath)
}
