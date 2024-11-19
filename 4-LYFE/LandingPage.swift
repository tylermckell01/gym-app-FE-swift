import SwiftUI

struct LandingPage: View {
    @Binding var navigationPath: [AppDestination]

    let backgroundColor = Color(red: 51/255, green: 69/255, blue: 127/255)

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Welcome to 4-LYFE")
                    .font(.largeTitle)
                    .foregroundColor(.white)

                Button("Create Account") {
                    navigationPath.append(.createAccount)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Login") {
                    navigationPath.append(.login)
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .navigationTitle("Landing Page")
    }
}

#Preview {
    @Previewable @State var mockNavigationPath: [AppDestination] = []

    return LandingPage(navigationPath: $mockNavigationPath)
}

