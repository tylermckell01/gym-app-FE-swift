import SwiftUI
import KeychainSwift
import Foundation


struct WorkoutsPage: View {
    @Binding var navigationPath: [AppDestination]
    
    let backgroundColor = Color(red: 51/255, green: 69/255, blue: 127/255)
    
    @State private var workouts: [Workout] = []
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var templateModalOpen = false
    
    let layout = [
        GridItem(.adaptive(minimum: 150), spacing: 20)
    ]
    
    struct ApiResponse: Decodable {
        let result: [Workout]
    }

    struct Workout: Decodable {
        let workout_id: UUID
        let workout_name: String
        let description: String?
        let length: Float
        let exercises: [Exercise]
        let user: User
    }

    struct Exercise: Decodable {
        let exercise_id: UUID
        let exercise_name: String
        let muscles_worked: String?
    }

    struct User: Decodable {
        let user_id: UUID
        let first_name: String
        let last_name: String
        let role: String
        let email: String
        let active: Bool
    }


    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            if isLoading {
                ProgressView("Loading Workouts...")
                    .foregroundColor(.white)
                    .font(.title)
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                
                
                ScrollView {
                    Spacer()
                    Button(action: {
                        templateModalOpen = true
                    }) {
                        Text("+ Workout Template")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                        }
                    
                    LazyVGrid(columns: layout, spacing: 20) {
                        ForEach(workouts, id: \.workout_id) { workout in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(workout.workout_name)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Text(workout.description ?? "No description")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .lineLimit(2)
                                
                                Text("\(workout.length, specifier: "%.0f") mins")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.1))
                            )
                        }
                        
                    }
                    .padding()
                }
            }
            VStack{
                Spacer()
                NavBar(navigationPath: $navigationPath)
            }
        }
        .navigationTitle("Workouts Page")
        .onAppear {
            fetchAllWorkoutData()
        }
        .sheet(isPresented: $templateModalOpen) {
                    WorkoutTemplateModalView()
                }
    }

    
    
    func fetchAllWorkoutData() {
        isLoading = true
        errorMessage = nil
        
        
        
        guard let url = URL(string: "http://127.0.0.1:8086/workouts") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let keychain = KeychainSwift()
        guard let token = keychain.get("authToken") else {
            errorMessage = "Missing authentication token"
            isLoading = false
            return
        }
        request.setValue(token, forHTTPHeaderField: "auth")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = "Error fetching workouts: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "No data received from server"
                }
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
                DispatchQueue.main.async {
                    self.workouts = apiResponse.result
                }
            } catch {
                DispatchQueue.main.async {
                    errorMessage = "Failed to decode workout data: \(error.localizedDescription)"
                }
            }
        }
        .resume()
    }
        struct WorkoutTemplateModalView: View {
            @Environment(\.dismiss) var dismiss
            
            @State private var templateName: String = ""
            @State private var description: String = ""
            @State private var length: String = ""
            
            @State var isLoading = false
            @State var errorMessage: String? = nil
            
            var body: some View {
                VStack {
                    
                    Text("Create Your Workout")
                        .font(.largeTitle)
                        .padding()
                    
                    TextField("Template Name", text: $templateName)
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Description", text: $description)
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Length", text: $length)
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    HStack{
                        Button("Cancel") {
                            dismiss()
                        }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                        
                        Button("Submit") {
                            createWorkoutTemplate()
                        }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.3).ignoresSafeArea())
        }
            func createWorkoutTemplate() {
//                print("clicked submit button")
                isLoading = true
                errorMessage = nil
                
                let keychain = KeychainSwift()
                guard let userId = keychain.get("userId"), let token = keychain.get("authToken") else {
                    errorMessage = "Missing authentication token or user ID"
                    isLoading = false
                    return
                }
                
                guard let workoutLength = Float(length) else {
                    errorMessage = "Invalid workout length"
                    isLoading = false
                    return
                }
                
                let postData: [String: Any] = [
                "workout_name": templateName,
                "description": description,
                "length": workoutLength,
                "user_id": userId
                ]
                
                guard let url = URL(string: "http://127.0.0.1:8086/workout") else {
                    errorMessage = "Invalid URL"
                    isLoading = false
                    return
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue(token, forHTTPHeaderField: "auth")
                request.httpBody = try? JSONSerialization.data(withJSONObject: postData)
                
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    DispatchQueue.main.async {
                        isLoading = false
                    }
                    DispatchQueue.main.async {
                        dismiss()
                    }
                }
                .resume()
            }
    }
}



#Preview {
    @Previewable @State var mockNavigationPath: [AppDestination] = []

    WorkoutsPage(navigationPath: $mockNavigationPath)
}
