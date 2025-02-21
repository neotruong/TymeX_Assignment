//
//  HomeSkeleton.swift
//  TymeX_Assignment
//
//  Created by PRO on 2/18/25.
//

import SwiftUI

struct SkeletonHeaderView: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 30)
                .padding(.bottom, 16)
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 20)
        }
        .padding()
    }
}


struct SkeletonListView: View {
    var body: some View {
        VStack {
            ForEach(0..<5, id: \.self) { _ in
                SkeletonUserItem()
            }
        }
    }
}

struct SkeletonUserItem: View {
    var body: some View {
        HStack {
            // Avatar Skeleton
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 64, height: 64)
            
            // User Infor Skeleton
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 16)
                    .padding(.bottom, 16)
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 14)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding(16)
    }
}


struct HomeSkeleton: View {
    var body: some View {
        VStack {
            SkeletonHeaderView()
            SkeletonListView()
        }
    }
}


