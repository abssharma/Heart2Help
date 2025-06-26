import SwiftUI

struct ContentView: View
{
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showSignup = false
    @State private var showHomeView = false
    @State private var errorMessage: ErrorMessage?

    var body: some View
    {
        VStack
        {
            if showHomeView
            {
                HomeView(showHomeView: $showHomeView)
                    .environmentObject(authViewModel)
            } else if showSignup
            {
                SignupView(showSignup: $showSignup, errorMessage: $errorMessage)
                    .environmentObject(authViewModel)
            } else
            {
                LoginView(showSignup: $showSignup, showHomeView: $showHomeView, errorMessage: $errorMessage)
                    .environmentObject(authViewModel)
            }
        }
        .alert(item: $errorMessage)
        { error in
            Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
        }
    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}

