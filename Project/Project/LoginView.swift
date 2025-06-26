import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var showSignup: Bool
    @Binding var showHomeView: Bool
    @Binding var errorMessage: ErrorMessage?

    @State private var email = ""
    @State private var password = ""

    var body: some View
    {
        VStack
        {
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            Button(action:
                    {
                authViewModel.login(email: email, password: password) { success in
                    if success
                    {
                        showHomeView = true
                    } else
                    {
                        errorMessage = ErrorMessage(message: "User not found. Try signing up.")
                    }
                }
            })
            {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()

            if let errorMessage = errorMessage?.message
            {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action:
            {
                showSignup = true
            })
            {
                Text("Don't have an account? Sign Up")
                    .padding()
            }
        }
        .padding()
    }
}

