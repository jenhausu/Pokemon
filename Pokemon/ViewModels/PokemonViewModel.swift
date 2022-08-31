//
//  PokemonViewModel.swift
//  Pokemon
//
//  Created by 蘇健豪 on 2022/8/27.
//

import Foundation
import NetworkKit

class PokemonViewModel: ObservableObject {
    @Published var pokemonDatas: [PokemonData] = []
    @Published var favritePokemons: [PokemonData] = []
    
    let httpClient: HTTPClientProtocol
    
    init(httpClient: HTTPClientProtocol = HTTPClient()) {
        self.httpClient = httpClient
    }
    
    @MainActor
    func getPokemonList(limit: Int, offset: Int) async throws {
        let request = PokemonListHTTPRequest(parameters: PokemonListHTTPRequest.Request(limit: limit, offset: offset))
        
        let response = try await httpClient.send(request).get()
        for pokemon in response.results {
            if let url = URL(string: pokemon.url) {
                let data = PokemonData(pokemonId: url.lastPathComponent, name: pokemon.name)
                if !pokemonDatas.contains(data) {
                    pokemonDatas.append(data)
                }
            }
        }
    }
    
    func getPokemon(id: String) async throws -> PokemonDataHTTPRequest.Response {
        let request = PokemonDataHTTPRequest(parameters: PokemonDataHTTPRequest.Request(id: id))
        
        let result = await httpClient.send(request)
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
    
    func addFavorite(_ pokemon: PokemonData) {
        if !favritePokemons.contains(pokemon) {
            favritePokemons.append(pokemon)
        }
    }
    
    func removeFavorite(_ pokemon: PokemonData) {
        if let index = favritePokemons.firstIndex(of: pokemon) {
            favritePokemons.remove(at: index)
        }
    }
    
}
