import Foundation
import UIKit

// MARK: - RegisterResponse
struct RegisterResponse: Decodable {
    let success: Bool
    let message: String
}

class NetworkManager {
    
    // MARK: - Hardcoded Token
    static let defaultToken = "eyJpdiI6Im9mV1NTMlFZQTlJeWlLQ3liVks1MGc9PSIsInZhbHVlIjoiRTJBbUR4dHp1dWJ3ekQ4bG85WVZya3ZpRGlMQ0g5ZHk4M"

    // MARK: - Register User
    static func registerUser(
        name: String,
        email: String,
        phone: String,
        positionID: Int = 1,
        photo: UIImage,
        token: String = defaultToken,
        completion: @escaping (Result<RegisterResponse, Error>) -> Void
    ) {
        // Email validation
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
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
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
        
        // Send request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
        }
        task.resume()
    }
    
    // MARK: - Helper: Append Form Parameter
    static func appendParameter(_ body: inout Data, boundary: String, name: String, value: String) {
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(value)\r\n".data(using: .utf8)!)
    }

    // MARK: - Helper: Append Photo
    static func appendPhoto(_ body: inout Data, boundary: String, imageData: Data, filename: String) {
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
    }

    // MARK: - Helper: Email Validation
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx =
        "(?:[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z]{2,}|\\[(?:(2(5[0-5]|[0-4]\\d)|1?\\d?\\d)(\\.(?!$)|$)){4}\\])"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
