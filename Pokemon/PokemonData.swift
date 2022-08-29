//
//  PokemonData.swift
//  Pokemon
//
//  Created by 蘇健豪 on 2022/8/27.
//

import Foundation

struct PokemonData: Identifiable, Equatable {
    static func == (lhs: PokemonData, rhs: PokemonData) -> Bool {
        lhs.pokemonId == rhs.pokemonId &&
        lhs.name == rhs.name
    }
    
    let id = UUID()
    let pokemonId: String
    let name: String
    var height: String?
    var weight: String?
    var types: [PokemonType]?
    var pictureUrl: URL?
    
    struct PokemonType {
        let name: String
    }
}
