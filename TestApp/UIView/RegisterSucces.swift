import SwiftUI

struct RegisterSucces: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
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
            
            Spacer().frame(height: 16)

            VStack(spacing: 16) {
                Image("successIMG")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    
                Text("User successfully registered")
                    .font(.none)
                    .foregroundColor(.black)
                    .padding(.top, 24)
                Button(action: {
                    // Add button action here
                }) {
                    Text("Got it")
                        .font(.title2)
                        .foregroundColor(.black)
                        .frame(width: 140, height: 48)
                        .background(Color(red: 244/255, green: 224/255, blue: 65/255))
                        .cornerRadius(24)
                        .padding(.top, 24)
                }
            }
            .padding()
            
            Spacer()
        }.navigationBarBackButtonHidden(true)
    }
}

struct RegisterSucces_Previews: PreviewProvider {
    static var previews: some View {
        RegisterSucces()
    }
}
