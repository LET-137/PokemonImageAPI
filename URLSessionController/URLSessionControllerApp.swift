//
//  URLSessionControllerApp.swift
//  URLSessionController
//
//  Created by 津本拓也 on 2024/08/29.
//

import SwiftUI

@main
struct URLSessionControllerApp: App {
    @StateObject private var pokemonForms = PokemonForms()
    @StateObject private var pokemonName = PokemonName()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(pokemonForms)
                .environmentObject(pokemonName)
        }
    }
}
