import SwiftUI

struct MainView: View {
    @State private var navigationPath: [AppDestination] = [] 

    var body: some View {
        NavigationStack(path: $navigationPath) {
            LandingPage(navigationPath: $navigationPath)
                .navigationDestination(for: AppDestination.self) { destination in
                    switch destination {
                    case .createAccount:
                        CreateAccountPage(navigationPath: $navigationPath)
                    case .login:
                        LoginPage(navigationPath: $navigationPath)
                    case .homePage:
                        HomePage(navigationPath: $navigationPath)
                    case .profile:
                        ProfilePage(navigationPath: $navigationPath)
                    case .workoutHistory:
                        WorkoutHistoryPage(navigationPath: $navigationPath)
                    case .workouts:
                        WorkoutsPage(navigationPath: $navigationPath)
                    case .exercises:
                        ExercisesPage(navigationPath: $navigationPath)
                    case .measure:
                        MeasurePage(navigationPath: $navigationPath)
                }
            }
        }
    }
}

#Preview{
    MainView()
}

