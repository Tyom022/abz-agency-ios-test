import Foundation

class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var errorMessage: String? // To show error messages in the UI
    
    func fetchUsers() {
        guard let url = URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/users?page=1&count=8") else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Check if there was an error
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Request failed: \(error.localizedDescription)"
                }
                return
            }
            
            // Check for valid data
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received."
                }
                return
            }

            do {
                // Attempt to decode the response
                let result = try JSONDecoder().decode(APIResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.users = result.users
                    // Optionally clear any previous errors here
                    self.errorMessage = nil
                }
                
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode data."
                    print("Decoding error:", error)
                }
            }
        }.resume()
    }
}
