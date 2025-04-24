//
//  CircleChekcBox.swift
//  TestApp
//
//  Created by Artyom Arzumanyan on 24.04.25.
//

import SwiftUI
struct CircleCheckbox: View {
    @Binding var selectedOption: Int
    var optionIndex: Int
    var label: String
    
    var body: some View {
        HStack {
            Button(action: {
                self.selectedOption = self.optionIndex
            }) {
                ZStack {
                    Circle()
                        .strokeBorder(Color.gray, lineWidth: 2)
                        .frame(width: 10, height: 10)
                    if selectedOption == optionIndex {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 8, height: 8)
                    }
                }
            }
            
            Text(label)
                .font(.system(size: 16))
                .foregroundColor(.black)
        }
        .padding(.vertical, 6)
        .padding(.leading)  // Align the label to the left side
    }
}
