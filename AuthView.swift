import SwiftUI
import Auth0

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSignedIn = false
    @State private var errorMessage = ""

    var body: some View {
        if isSignedIn {
            ContentView()
        } else {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Login") {
                    login()
                }
                .padding()
                
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            .padding()
        }
    }

    private func login() {
        Auth0
            .authentication()
            .login(
                usernameOrEmail: email,
                password: password,
                realm: "Username-Password-Authentication",
                audience: "https://YOUR_DOMAIN/userinfo",
                scope: "openid profile"
            )
            .start { result in
                switch result {
                case .success(let credentials):
                    isSignedIn = true
                    print("Logged in with credentials: \(credentials)")
                case .failure(let error):
                    errorMessage = error.localizedDescription
                    print("Failed to log in: \(error)")
                }
            }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
