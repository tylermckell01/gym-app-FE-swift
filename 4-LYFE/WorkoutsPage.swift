import SwiftUI

struct WorkoutsPage: View {
    let backgroundColor = Color(red: 51/255, green: 69/255, blue: 127/255)
    
    
    var body: some View {
        NavigationView{
            ZStack{
                backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing:15){
                    
                    Text("this is the workouts page")
                                        
                }
            }
            .navigationTitle("My Workouts Page")
        }
    }
}


#Preview{
    WorkoutsPage()
}

