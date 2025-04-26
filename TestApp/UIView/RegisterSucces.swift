import SwiftUI

struct RegisterSucces: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            // Centered content
            VStack {
                Spacer()

                VStack(spacing: 16) {
                    Image("successIMG")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)

                    Text("User successfully registred")
                        .font(.title3)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)

                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Got it")
                            .font(.title2)
                            .foregroundColor(.black)
                            .frame(width: 140, height: 48)
                            .background(Color(red: 244/255, green: 224/255, blue: 65/255))
                            .cornerRadius(24)
                    }
                    .padding(.top, 8)
                }

                Spacer()
            }

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("close")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                            .padding()
                    }
                }
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
}

struct RegisterSuccess_Previews: PreviewProvider {
    static var previews: some View {
        RegisterSucces()
    }
}
