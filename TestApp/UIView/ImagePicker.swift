//
//  ImagePicker.swift
//  TestApp
//
//  Created by Artyom Arzumanyan on 24.04.25.
//
import SwiftUI
import UIKit

struct ImagePickerController: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isImagePickerPresented: Bool
    var imageSource: UIImagePickerController.SourceType
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerController
        
        init(parent: ImagePickerController) {
            self.parent = parent
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isImagePickerPresented = false
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.isImagePickerPresented = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = imageSource
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No need to update the image picker when the state changes
    }
}
