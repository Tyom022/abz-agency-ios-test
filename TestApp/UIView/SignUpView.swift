//
//  SignUpView.swift
//  TestApp
//
//  Created by Artyom Arzumanyan on 24.04.25.
//
import SwiftUI
import UIKit

struct SignUpView: View {
    
    @State private var selectedOption = 0
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var photo: UIImage? = nil
    
    @State private var isNameFocused = false
    @State private var isEmailFocused = false
    @State private var isPhoneFocused = false
    @State private var isPhotoFocused = false
    
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var showValidationMessages = false
    
    @State private var navigateToSuccess = false
    @State private var navigateToError = false
    
    private var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && !phone.isEmpty && selectedImage != nil
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    let token = "eyJpdiI6Im9mV1NTMlFZQTlJeWlLQ3liVks1MGc9PSIsInZhbHVlIjoiRTJBbUR4dHp1dWJ3ekQ4bG85WVZya3ZpRGlMQ0g5ZHk4M"
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    // Name TextField
                    CustomTextField(
                        text: $name,
                        placeholder: "Your name",
                        isFocused: $isNameFocused,
                        borderColor: name.isEmpty && showValidationMessages ? .red : .gray
                    )
                    if showValidationMessages && name.isEmpty {
                        Text("Required field")
                            .font(.system(size: 10))
                            .foregroundColor(.red)
                            .padding(.leading, 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // Email TextField
                    CustomTextField(
                        text: $email,
                        placeholder: "Email",
                        isFocused: $isEmailFocused,
                        borderColor: email.isEmpty && showValidationMessages ? .red : .gray
                    )
                    if showValidationMessages && email.isEmpty {
                        Text("Invalid email format")
                            .font(.system(size: 10))
                            .foregroundColor(.red)
                            .padding(.leading, 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // Phone TextField
                    CustomTextField(
                        text: $phone,
                        placeholder: "Phone",
                        isFocused: $isPhoneFocused,
                        borderColor: phone.isEmpty && showValidationMessages ? .red : .gray,
                        keyboardType: .phonePad
                    )
                    if showValidationMessages && phone.isEmpty {
                        Text("Required field")
                            .font(.system(size: 10))
                            .foregroundColor(.red)
                            .padding(.leading, 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    if !showValidationMessages {
                        Text("+38 (XXX) XXX - XX - XX")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .frame(height: 16)
                            .padding(.leading, 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    VStack {
                        Text("Select your position")
                            .font(.headline)
                            .padding(.top, 8)
                            .padding(.leading, 20)
                        
                        // Circle Checkboxes with single selection logic
                        VStack(alignment: .leading, spacing: 16) {
                            CircleCheckbox(selectedOption: $selectedOption, optionIndex: 1, label: "Frontend developer")
                            CircleCheckbox(selectedOption: $selectedOption, optionIndex: 2, label: "Backend developer")
                            CircleCheckbox(selectedOption: $selectedOption, optionIndex: 3, label: "Designer")
                            CircleCheckbox(selectedOption: $selectedOption, optionIndex: 4, label: "QA")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Photo Upload TextField
                    ZStack {
                        HStack {
                            Text("Upload your photo")
                                .padding(.leading, 10) // Padding for the left side
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(showValidationMessages && selectedImage == nil ? .red : .gray)

                            Spacer()
                            Button(action: {
                                isImagePickerPresented.toggle()
                            }) {
                                Text("Upload")
                                    .foregroundColor(Color(red: 0/255, green: 155/255, blue: 189/255))
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 12)
                                    .background(Color.clear)
                                    .cornerRadius(8)
                            }
                            .padding(.trailing, 10) // Padding for the right side
                        }
                        .padding()
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(showValidationMessages && selectedImage == nil ? Color.red : Color.gray.opacity(0.4), lineWidth: 1)
                        )
                    }.padding(.leading, 15)
                        .padding(.trailing, 15)
                    
                    if showValidationMessages && selectedImage == nil {
                        Text("Photo is required")
                            .font(.system(size: 10))
                            .foregroundColor(.red)
                            .frame(height: 16)
                            .padding(.leading, 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Button(action: {
                        showValidationMessages = true
                        
                        // Proceed with registration if all fields are valid
                        if name.isEmpty || email.isEmpty || phone.isEmpty || selectedImage == nil {
                            return
                        }

                        // Email validation
                        if !isValidEmail(email) {
                            navigateToError = true  // Navigate to RegisterError if email is invalid
                            return
                        }
                        
                        // Proceed with registration if all fields are valid
                        NetworkManager.registerUser(name: name, email: email, phone: phone, positionID: selectedOption + 1, photo: selectedImage!, token: token) { result in
                            switch result {
                            case .success(let response):
                                // Handle successful registration response
                                print("User registered successfully: \(response.message)")
                                navigateToSuccess = true // Navigate to RegisterSuccess on success
                            case .failure(let error):
                                // Handle failure (e.g., phone/email already exists)
                                print("Error: \(error.localizedDescription)")
                                navigateToError = true  // Navigate to RegisterError in case of failure
                            }
                        }
                    }) {
                        Text("Sign Up")
                            .foregroundColor(.black)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .frame(width: 140)
                            .background(isFormValid ? Color(red: 244/255, green: 224/255, blue: 65/255) : Color.gray)
                            .cornerRadius(24)
                            .disabled(!isFormValid)
                    }
                    
                    Spacer()
                }
            }
            .padding()
            .onTapGesture {
                hideKeyboard() // 👈 tap outside closes the keyboard
            }
            .scrollDisabled(true)
            .ignoresSafeArea(.keyboard)
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePickerController(selectedImage: $selectedImage, isImagePickerPresented: $isImagePickerPresented, imageSource: imageSource)
            }
            
            // Using navigationDestination inside NavigationStack
            .navigationDestination(isPresented: $navigateToSuccess) {
                RegisterSucces()
            }
            .navigationDestination(isPresented: $navigateToError) {
                RegisterError()
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        // Simple email validation logic (adjust as needed)
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: [])
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) != nil
    }
    
    struct CustomTextField: View {
        @Binding var text: String
        var placeholder: String
        @Binding var isFocused: Bool
        var borderColor: Color
        var keyboardType: UIKeyboardType = .default //
        var body: some View {
            VStack {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(borderColor, lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .onTapGesture {
                        self.isFocused = true
                    }
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
