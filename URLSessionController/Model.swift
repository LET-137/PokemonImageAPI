//
//  GuriFile.swift
//  URLSessionController
//
//  Created by 津本拓也 on 2024/08/29.
//

import Foundation
import SwiftUI

struct PokemonNameRequest: Decodable {
    var forms: [Forms]
}

struct Forms: Decodable {
    var name: String?
    var url: String?
}

class PokemonName: ObservableObject {
    @Published var formsURL: String = ""
    @Published var errorMessage: String = ""
    
    func fetchFormsURL(url: String) async throws {
        guard let urlString = URL(string: url) else { return }
        do {
            var request = URLRequest(url: urlString)
            request.httpMethod = "GET"
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let json = try JSONDecoder().decode(PokemonNameRequest.self, from: data)
            if let nameURL = json.forms.first?.url {
                DispatchQueue.main.async {
                    self.formsURL = nameURL
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "検索できませんでした"
            }
            print("Error: \(error)")
        }
    }
}


struct PokemonFormsRequest: Decodable {
    var sprites: Sprites?
}

struct Sprites: Decodable {
    var back_default: String?
    var back_female: String?
    var back_shiny: String?
    var back_shiny_female: String?
    var front_default: String?
    var front_female: String?
    var front_shiny: String?
    var front_shiny_female: String?
}

class PokemonForms: ObservableObject {
    @Published var pokemonURL: [String] = []
    
    func fetchPokemonImage(url: String) async throws {
        guard let url = URL(string: url) else { return }
        do {
            var formRequest = URLRequest(url: url)
            formRequest.httpMethod = "GET"
            
            let (formData, _) = try await URLSession.shared.data(for: formRequest)
            let formJson = try JSONDecoder().decode(PokemonFormsRequest.self, from: formData)
            guard let defaultForm = formJson.sprites else { return }
            
            DispatchQueue.main.async {
                self.pokemonURL.append(defaultForm.back_default ?? "")
                self.pokemonURL.append(defaultForm.back_female ?? "")
                self.pokemonURL.append(defaultForm.back_shiny ?? "")
                self.pokemonURL.append(defaultForm.back_shiny_female ?? "")
                self.pokemonURL.append(defaultForm.front_default ?? "")
                self.pokemonURL.append(defaultForm.front_female ?? "")
                self.pokemonURL.append(defaultForm.front_shiny ?? "")
                self.pokemonURL.append(defaultForm.front_shiny_female ?? "")
            }
        } catch {
            print("Error: \(error)")
        }
    }
}
