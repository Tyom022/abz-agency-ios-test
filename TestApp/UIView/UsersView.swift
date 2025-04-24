import SwiftUI

struct UsersView: View {
    @StateObject private var viewModel = UsersViewModel()

    var body: some View {
        VStack {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                if viewModel.users.isEmpty {
                    ProgressView("Loading users...")
                        .padding()
                } else {
                    List(viewModel.users) { user in
                        HStack(alignment: .top, spacing: 12) {
                            AsyncImage(url: URL(string: user.photo)) { image in
                                image.resizable()
                                    .scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 72, height: 72)
                            .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 6) {
                                Text(user.name)
                                    .font(.system(size: 20, weight: .bold))

                                Text(user.position)
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)

                                Text(user.email)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)

                                Text(user.phone)
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)

                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchUsers()
        }
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        UsersView()
    }
}
