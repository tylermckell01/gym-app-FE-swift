import SwiftUI

struct NavBar: View {
    @Binding var navigationPath: [AppDestination]
    
    var body: some View{
    VStack(spacing: 0) {
        
        Rectangle()
            .frame(height: 2)
            .foregroundColor(.gray)
        
    HStack() {
        
    Spacer()
        
        Button("Profile"){
             navigationPath.append(.profile)
        }
        .foregroundColor(.gray)
        .padding(.vertical, 20)
        
    Spacer()
        
        Button("History"){
             navigationPath.append(.workoutHistory)
        }
        .foregroundColor(.gray)
        .padding(.vertical, 20)
        
    Spacer()
        
        Button("Workouts") {
            navigationPath.append(.workouts)
        }
        .foregroundColor(.gray)
        .padding(.vertical, 20)
        
    Spacer()
        
        Button("Exercise"){
             navigationPath.append(.exercises)
        }
        .foregroundColor(.gray)
        .padding(.vertical, 20)
        
    Spacer()
        
        Button("Measure"){
              navigationPath.append(.measure)
        }
        .foregroundColor(.gray)
        .padding(.vertical, 20)
        
    Spacer()
    }
    .background(Color.black)
    .frame(maxWidth: .infinity)
    .font(. system(size: 14))
    }
}
}

#Preview(){
    @Previewable @State var mockNavigationPath: [AppDestination] = []

    NavBar(navigationPath: $mockNavigationPath)
}
