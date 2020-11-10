//
//  MainMenuContentView.swift
//  AR tmp
//
//  Created by Elias Lankinen on 11/10/20.
//

import SwiftUI


struct MainMenuContentView: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: ShootingContentView()){
                Text("Shooting")
            }
        }
    }
}

