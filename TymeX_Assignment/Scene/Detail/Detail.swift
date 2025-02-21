import SwiftUI
import Combine

struct Detail: View {
    @ObservedObject var viewModel: DetailViewModel
    var username: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let user = viewModel.userDetail {
                    UserItem(userName: user.login, userProfile: user.location ?? "Unknown", userAvatarUrl: user.avatarURL)
                        .listRowSeparator(.hidden)
                        .padding(16)
                    
                    HStack {
                        Spacer()
                        
                        VStack {
                            Text("Followers")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Text("\(user.followers)")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                        .padding(8)
                        
                        VStack {
                            Text("Following")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Text("\(user.following)")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                        .padding(8)
                        
                        Spacer()
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .padding(.horizontal, 16)
                    
                    VStack(alignment: .leading) {
                        Text("Profile")
                            .font(.title)
                            .fontWeight(.bold)
                        Text(user.htmlURL)
                            .foregroundColor(.blue)
                    }
                    .padding(16)
                } else {
                    Text("Loading...")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .background(.white)
        }
        .navigationTitle("User Details")
        .onAppear {
            viewModel.apply(.onAppear(username: username))
        }
    }
}
