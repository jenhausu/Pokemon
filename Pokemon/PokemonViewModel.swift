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
    
    private let httpClient = HTTPClient()
    
    @MainActor
    func getPokemonList(limit: Int, offset: Int) async throws {
        let request = PokemonListRequest(parameters: PokemonListRequest.Request(limit: limit, offset: offset))
        
        let result = await httpClient.send(request)
        switch result {
        case .success(let response):
            for pokemon in response.results {
                if let url = URL(string: pokemon.url) {
                    pokemonDatas.append(PokemonData(pokemonId: url.lastPathComponent, name: pokemon.name))
                }
            }
        case .failure(let error):
            throw error
        }
    }
    
    func getPokemon(id: String) async throws -> PokemonDataRequest.Response {
        let request = PokemonDataRequest(parameters: PokemonDataRequest.Request(id: id))
        
        let result = await httpClient.send(request)
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
    
}
