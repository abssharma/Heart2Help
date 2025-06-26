import SwiftUI

struct SignupView: View
{
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var showSignup: Bool
    @Binding var errorMessage: ErrorMessage?

    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    var body: some View
    {
        VStack
        {
            TextField("Username", text: $username)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            TextField("Email", text: $email)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            TextField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            TextField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            Button(action:
                    {
                guard password == confirmPassword else
                {
                    errorMessage = ErrorMessage(message: "Passwords do not match")
                    return
                }
                authViewModel.signUp(username: username, email: email, password: password)
                { success in
                    if success
                    {
                        showSignup = false
                    } else
                    {
                        errorMessage = ErrorMessage(message: authViewModel.errorMessage ?? "Failed to sign up")
                    }
                }
            })
            {
                Text("Sign Up")
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
        }
        .padding()
    }
}

