import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject
{
    @Published var isSignedIn = false
    @Published var errorMessage: String?

    private let auth = Auth.auth()
    private let db = Firestore.firestore()

    func signUp(username: String, email: String, password: String, completion: @escaping (Bool) -> Void)
    {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error
            {
                self?.errorMessage = "Signup failed: \(error.localizedDescription)"
                completion(false)
                return
            }
            
            guard let uid = result?.user.uid else
            {
                self?.errorMessage = "Failed to retrieve user ID"
                completion(false)
                return
            }
            
            let userData: [String: Any] =
            [
                "username": username,
                "email": email,
                "password": password,
                "createdAt": Timestamp(date: Date())
            ]
            
            self?.db.collection("users").document(uid).setData(userData)
            { error in
                if let error = error
                {
                    self?.errorMessage = "Failed to save user data: \(error.localizedDescription)"
                    completion(false)
                } else
                {
                    self?.isSignedIn = true
                    completion(true)
                }
            }
        }
    }

    func login(email: String, password: String, completion: @escaping (Bool) -> Void)
    {
        print("Attempting login with email: \(email)")

        auth.signIn(withEmail: email, password: password)
        { [weak self] result, error in
            if let error = error
            {
                print("Login failed: \(error.localizedDescription)")
                self?.errorMessage = "Login failed: \(error.localizedDescription)"
                completion(false)
            } else
            {
                print("Login successful!")
                self?.isSignedIn = true
                completion(true)
            }
        }
    }
}

