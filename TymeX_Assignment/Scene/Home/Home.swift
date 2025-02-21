//
//  CacheServceImp.swift
//  TymeX_Assignment
//
//  Created by PRO on 2/21/25.
//

import SwiftUI

struct Home: View {
    @ObservedObject var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                HomeSkeleton()
            } else {
                VStack {
                    Text("Github Users")
                        .font(.title)

                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.listUsers, id: \.login) { user in
                                NavigationLink(destination: Detail(viewModel: DetailViewModel(), username: user.login)) {
                                    UserItem(userName: user.login, userProfile: user.html_url, userAvatarUrl: user.avatar_url)
                                        .listRowSeparator(.hidden)
                                        .padding(.vertical, 8)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }

                            if !viewModel.listUsers.isEmpty {
                                ProgressView()
                                    .onAppear {
                                        viewModel.apply(.loadMore)
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .background(Color.white)
                }
            }
        }
        .onAppear {
            viewModel.apply(.onAppear)
        }
    }
}
