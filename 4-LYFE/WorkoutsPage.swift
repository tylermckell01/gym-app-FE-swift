import SwiftUI

struct Workout: Decodable {
    let id: Int
    let name: String
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
                    
                    Text("this is the workouts page")
                                        
                    List(workouts, id: \.id) {
                        workout in
                        Text(workout.name)
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
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching workouts: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received.")
                return
            }
            
            do {
                let workouts = try JSONDecoder().decode([Workout].self, from: data)
                print("Fetched workouts:", workouts)
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

