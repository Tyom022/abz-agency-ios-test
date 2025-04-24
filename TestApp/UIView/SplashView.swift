//
//  SplashView.swift
//  TestApp
//
//  Created by Artyom Arzumanyan on 24.04.25.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @EnvironmentObject var networkMonitor: NetworkMonitor

    var body: some View {
        if isActive {
            ContentView()
                .environmentObject(networkMonitor)
        } else {
            VStack {
                Spacer()
                Image("Cat")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 95, height: 65)
                    
                Text("TESTTASK")
                    .font(.title)
                    .fontWeight(.regular)
                    .foregroundColor(Color(red: 0, green: 0, blue: 0,opacity: 0.87))
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 244/255, green: 224/255, blue: 65/255))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
