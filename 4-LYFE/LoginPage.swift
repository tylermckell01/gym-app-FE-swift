import SwiftUI

struct LoginPage: View {
    let backgroundColor = Color(red: 51/255, green: 69/255, blue: 127/255)

    
    var body: some View {
        ZStack{
            
            VStack{
                Text("login page text")
            }
        }
        .navigationTitle("Login Page")
    }
}

#Preview{
    LoginPage()
}
