//
//  MainMenuContentView.swift
//  AR tmp
//
//  Created by Elias Lankinen on 11/10/20.
//

import SwiftUI

enum Game {
    case shooting
}

struct MainMenuContentView: View {
    @State var selectedGame: Game?
    var body: some View {
        if selectedGame == nil {
            List {
                Button("Shooting") {
                    selectedGame = .shooting
                }
            }
        }
        if selectedGame != nil, selectedGame! == .shooting {
            ShootingContentView()
        }
    }
}

