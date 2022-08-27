//
//  PokemonData.swift
//  Pokemon
//
//  Created by 蘇健豪 on 2022/8/27.
//

import Foundation

struct PokemonData: Identifiable, Equatable {
    static func == (lhs: PokemonData, rhs: PokemonData) -> Bool {
        lhs.id == rhs.id
    }
    
    let id = UUID()
    let PokemonId: String
    let name: String
    let height: String
    let weight: String
    let types: [PokemonType]
    let pictureUrl: URL?
    
    struct PokemonType {
        let name: String
    }
}
