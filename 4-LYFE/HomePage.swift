import SwiftUI
import KeychainSwift
import Foundation


struct HomePage: View {
    @Binding var navigationPath: [AppDestination]
    let backgroundColor = Color(red: 51/255, green: 69/255, blue: 127/255)
    
    @State private var firstName: String? = nil
    
    
    //    struct ApiResponse: Decodable {
    //        let result: [userInfo]
    //    }
    
    struct User: Decodable {
        let user_id: UUID
        let first_name: String
        //        let last_name: String
        //        let role: String
        //        let email: String
        //        let active: Bool
    }
    
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                //                Text("Home Page")
                //                    .font(.largeTitle)
                //                    .padding()
                
                Text("Hello \(firstName ?? "user")")
                
                Spacer()
                
                NavBar(navigationPath: $navigationPath)
            }
        }
        .navigationTitle("Home Page")
        .onAppear {
                    fetchFirstName()
                }
    }
    
    let layout = [
        GridItem(.adaptive(minimum: 150), spacing: 20)
    ]
    
    private func fetchFirstName() {
            let keychain = KeychainSwift()
            firstName = keychain.get("user")
        }
}



#Preview {
    @Previewable @State var mockNavigationPath: [AppDestination] = []

    HomePage(navigationPath: $mockNavigationPath)
}

