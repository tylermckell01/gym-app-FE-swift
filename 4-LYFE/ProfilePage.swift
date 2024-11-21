import SwiftUI
import KeychainSwift
import Foundation


struct ProfilePage: View {
    @Binding var navigationPath: [AppDestination]
    let backgroundColor = Color(red: 51/255, green: 69/255, blue: 127/255)
    
    
//    struct ApiResponse: Decodable {
//        let result: [userInfo]
//    }

//    struct User: Decodable {
//        let user_id: UUID
//        let first_name: String
//        let last_name: String
//        let role: String
//        let email: String
//        let active: Bool
//    }


    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Text("Profile Page")
                    .font(.largeTitle)
                    .padding()
                
                Text("Hello 'User'")
                
                Spacer()
                
                NavBar(navigationPath: $navigationPath)
                
            }
        }
        .navigationTitle("Profile Page")
    }

    let layout = [
        GridItem(.adaptive(minimum: 150), spacing: 20)
    ]
}



#Preview {
    @Previewable @State var mockNavigationPath: [AppDestination] = []

    ProfilePage(navigationPath: $mockNavigationPath)
}

