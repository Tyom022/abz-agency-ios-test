//
//  ApiError.swift
//  TestApp
//
//  Created by Artyom Arzumanyan on 24.04.25.
//


import Foundation

// Define the error type
enum APIError: Error {
    case badURL
    case requestFailed
    case decodingError
    case serverError(String) // In case of a custom message from the server
    case unknown
}
