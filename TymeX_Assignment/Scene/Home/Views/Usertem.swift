//
//  Usertem.swift
//  TymeX_Assignment
//
//  Created by PRO on 2/18/25.
//

import SwiftUI

struct UserItem: View {
    var userName: String
    var userProfile: String
    var userAvatarUrl: String
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: userAvatarUrl)) { image in
                image.resizable()
            } placeholder: {
                Color.gray // Placeholder color
            }
            .frame(width: 64, height: 64)
            .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(userName)
                    .font(.headline)
                    .foregroundStyle(.black)
                Text(userProfile)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .padding(.trailing, 16)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}
