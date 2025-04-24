import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab = 0
    @EnvironmentObject var networkMonitor: NetworkMonitor
    var body: some View {
        Group {
            if networkMonitor.isConnected {
                TabView(selection: $selectedTab) {
                    UsersView()
                        .tabItem {
                            Image(selectedTab == 0 ? "Symbol" : "Symbol(Gray)")
                                .frame(width: 40, height: 17)
                            Text("Users")
                                .font(.custom("Nunito Sans", size: 16))
                                .fontWeight(.semibold) // Equivalent to 600 weight
                                .lineSpacing(8) // Adjust line height
                                .kerning(0.1) // Letter spacing
                                .foregroundColor(selectedTab == 0 ? Color(red: 0/255, green: 189/255, blue: 211/255) : .gray) // Change text color based on selection
                                .frame(maxWidth: .infinity, alignment: .center) // Center the text horizontally
                                .multilineTextAlignment(.center)
                        }
                        .tag(0)
                    SignUpView()
                        .tabItem {
                            Image(selectedTab == 1 ? "SymbolBlue" : "SymbolGray")
                                .frame(width: 40, height: 17)
                            Text("Users")
                                .font(.custom("Nunito Sans", size: 16))
                                .fontWeight(.semibold) // Equivalent to 600 weight
                                .lineSpacing(8) // Adjust line height
                                .kerning(0.1) // Letter spacing
                                .foregroundColor(selectedTab == 0 ? Color(red: 0/255, green: 189/255, blue: 211/255) : .gray) // Change text color based on selection
                                .frame(maxWidth: .infinity, alignment: .center) // Center the text horizontally
                                .multilineTextAlignment(.center)
                        }
                        .tag(1)
                }
            } else {
                OfflineView()
            }
        }
        .onChange(of: networkMonitor.isConnected) { newValue in
            if newValue {
                print("Internet connection is back")
            } else {
                print("You are offline")
            }
        }
    }
}
