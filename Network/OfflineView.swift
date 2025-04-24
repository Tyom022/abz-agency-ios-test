//
//  OfflineView.swift
//  TestApp
//
//  Created by Artyom Arzumanyan on 24.04.25.
//

import SwiftUI

struct OfflineView: View {
    
    @EnvironmentObject var networkMonitor: NetworkMonitor
    var body: some View {
        VStack(spacing: 16) {
            Image("NoInternet")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .foregroundColor(.gray)
            
            Text("There is no internet connection")
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(.black)
                .padding(.top, 24)
            
            Button(action: {
                networkMonitor.checkNow()
            }) {
                Text("Try again")
                    .foregroundColor(.black)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .frame(width: 140)
                    .background(Color(red: 244/255, green: 224/255, blue: 65/255))
                    .cornerRadius(24)
            }
            .padding(.top, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .ignoresSafeArea()
    }
}
