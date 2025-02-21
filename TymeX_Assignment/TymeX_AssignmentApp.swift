//
//  TymeX_AssignmentApp.swift
//  TymeX_Assignment
//
//  Created by PRO on 2/18/25.
//

import SwiftUI

@main
struct TymeX_AssignmentApp: App {
    var body: some Scene {
        WindowGroup {
            Home(viewModel: HomeViewModel())
        }
    }
}
