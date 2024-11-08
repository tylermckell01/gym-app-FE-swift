import SwiftUI

struct LandingPage: View {
    let backgroundColor = Color(red: 51/255, green: 69/255, blue: 127/255)

    
    var body: some View {
        NavigationView{
            ZStack{
                backgroundColor
                    .ignoresSafeArea()
                
                VStack {
                    Text("4-LYFE")
                        .font(.system(size: 45))
                        .padding()
                    
                    NavigationLink(destination: CreateAccountPage()) {
                        Text("Create Account")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                    
                    VStack{
                        Text("Already have an account?")
                            .padding(.top, 250)
                        
                        NavigationLink(destination: LoginPage()) {
                            Text("Login")
                            
                        }
                    }
                    //                .padding(10)
                }
                .padding(.top, 200)
            }
            .navigationTitle("Landing Page")
        }
    }
}
#Preview {
    LandingPage()
}
