import SwiftUI

struct MainView: View {
    @State private var navigationPath: [AppDestination] = [] 

    var body: some View {
        NavigationStack(path: $navigationPath) {
            LandingPage(navigationPath: $navigationPath)
                .navigationDestination(for: AppDestination.self) { destination in
                    switch destination {
                    case .createaccount:
                        CreateAccountPage(navigationPath: $navigationPath)
                    case .login:
                        LoginPage(navigationPath: $navigationPath)
                    case .homePage:
                        HomePage(navigationPath: $navigationPath)
                    case .workouts:
                        WorkoutsPage()
                }
            }
        }
    }
}

#Preview{
    MainView()
}

