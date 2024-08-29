//
//  ContentView.swift
//  URLSessionController
//
//  Created by 津本拓也 on 2024/08/29.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var pokemonforms: PokemonForms
    @EnvironmentObject var pokemonName: PokemonName
    @State private var pokemonURLString: [String] = []
    @State private var inputPokemonName: String = ""
    
    var columns = [GridItem(.adaptive(minimum: 100, maximum: 200))]
    
    var body: some View {
        VStack {
            ScrollView {
                TextField("ポケモンの番号、または英語の名前",text: $inputPokemonName)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                Button("ポケモンの画像を表示") {
                    pokemonName.errorMessage = ""
                    pokemonforms.pokemonURL = []
                    pokemonURLString = []
                    let url = "https://pokeapi.co/api/v2/pokemon/\(inputPokemonName)"
                    
                    Task {
                        try await pokemonName.fetchFormsURL(url:url)
                        try await pokemonforms.fetchPokemonImage(url: pokemonName.formsURL)
                        DispatchQueue.main.async {
                            pokemonforms.pokemonURL.forEach { url in
                                pokemonURLString.append(url)
                            }
                        }
                    }
                }
                .fontWeight(.bold)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
                .padding()
                 
                Text(pokemonName.errorMessage)
                
                LazyVGrid(columns: columns,spacing: 10) {
                    ForEach(pokemonURLString, id: \.self) { url in
                        if let urlString = URL(string: url) {
                            AsyncImage(url: urlString) { phase in
                                if case .success(let image) = phase {
                                    image.resizable().aspectRatio(contentMode: .fit).frame(width: 200, height: 200)
                                } else if case .failure(_) = phase {
                                    Image(systemName: "exclamationmark.triangle.fill").resizable().aspectRatio(contentMode: .fit).frame(width: 200, height: 200)
                                } else {
                                    ProgressView().frame(width: 200, height: 200)
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
        }
        .padding()
    }
}
