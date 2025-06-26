import SwiftUI
import Firebase

@main
struct ProjectApp: App
{
    @StateObject private var authViewModel = AuthViewModel()

    init()
    {
        FirebaseApp.configure()
    }

    var body: some Scene
    {
        WindowGroup
        {
            NavigationView
            {
                ContentView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

