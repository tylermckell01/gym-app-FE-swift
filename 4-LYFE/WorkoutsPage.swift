import SwiftUI
import KeychainSwift
import Foundation

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


struct WorkoutsPage: View {
    let backgroundColor = Color(red: 51/255, green: 69/255, blue: 127/255)
    @State private var workouts: [Workout] = []
    
    var body: some View {
        NavigationView{
            ZStack{
                backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing:15){
                    backgroundColor
                    
                    List(workouts, id: \.workout_id)
                    {
                        workout in
                        Text(workout.workout_name)
                        Text(workout.description ?? "no description")
//                        Text(workout.exercises)
                        backgroundColor
                    }
                }
            }
            .navigationTitle("My Workouts Page")
            .onAppear{
                fetchAllWorkoutData()
            }
        }
    }
    
    func fetchAllWorkoutData() {
        guard let url = URL(string: "http://127.0.0.1:8086/workouts") else {
            print("did not make api request")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let keychain = KeychainSwift()
        let token = keychain.get("authToken")
        request.setValue(token, forHTTPHeaderField: "auth")
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching workouts: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received.")
                return
            }
            
            print("Raw JSON data:", String(data: data, encoding: .utf8) ?? "Unable to convert data to string")
            
            do {
                let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
                DispatchQueue.main.async {
                    self.workouts = apiResponse.result
                    print("Fetched workouts:", apiResponse.result)
                }
            } catch {
                print("Failed to decode workout data:", error)
            }
        }
        
        task.resume()
    }
}


#Preview{
    WorkoutsPage()
}
