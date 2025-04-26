import Foundation
import UIKit


struct RegisterResponse: Decodable {
    let success: Bool
    let message: String
}


class NetworkManager {
    
    // MARK: - Register User (with automatic token fetch)
    static func registerUser(
        name: String,
        email: String,
        phone: String,
        positionID: Int = 1,
        photo: UIImage,
        completion: @escaping (Result<RegisterResponse, Error>) -> Void
    ) {
        fetchToken { result in
            switch result {
            case .success(let token):
                registerUserWithToken(
                    name: name,
                    email: email,
                    phone: phone,
                    positionID: positionID,
                    photo: photo,
                    token: token,
                    completion: completion
                )
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Fetch Token
    public static func fetchToken(completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/token") else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid token URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let token = json["token"] as? String {
                    completion(.success(token))
                } else {
                    completion(.failure(NSError(domain: "", code: 422, userInfo: [NSLocalizedDescriptionKey: "Invalid token format"])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // MARK: - Internal: Register With Token
    private static func registerUserWithToken(
        name: String,
        email: String,
        phone: String,
        positionID: Int,
        photo: UIImage,
        token: String,
        completion: @escaping (Result<RegisterResponse, Error>) -> Void
    ) {
        guard isValidEmail(email) else {
            let error = NSError(domain: "", code: 422, userInfo: [NSLocalizedDescriptionKey: "Invalid email address"])
            completion(.failure(error))
            return
        }

        guard let url = URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/users") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(token, forHTTPHeaderField: "Token")

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        appendParameter(&body, boundary: boundary, name: "name", value: name)
        appendParameter(&body, boundary: boundary, name: "email", value: email)
        appendParameter(&body, boundary: boundary, name: "phone", value: phone)
        appendParameter(&body, boundary: boundary, name: "position_id", value: "\(positionID)")

        // Append photo
        if let imageData = photo.jpegData(compressionQuality: 0.5) ?? photo.pngData() {
            appendPhoto(&body, boundary: boundary, imageData: imageData, filename: "photo.jpg")
        } else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid image format"])))
            return
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                let err = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(err))
                return
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("Raw Response: \(responseString)")
            }

            do {
                let responseJSON = try JSONDecoder().decode(RegisterResponse.self, from: data)
                if responseJSON.success {
                    completion(.success(responseJSON))
                } else {
                    let error = NSError(domain: "", code: 409, userInfo: [NSLocalizedDescriptionKey: responseJSON.message])
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // MARK: - Other helpers (unchanged)
    static func appendParameter(_ body: inout Data, boundary: String, name: String, value: String) {
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(value)\r\n".data(using: .utf8)!)
    }

    static func appendPhoto(_ body: inout Data, boundary: String, imageData: Data, filename: String) {
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
    }

    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx =
        "(?:[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z]{2,}|\\[(?:(2(5[0-5]|[0-4]\\d)|1?\\d?\\d)(\\.(?!$)|$)){4}\\])"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}

