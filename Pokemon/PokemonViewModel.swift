//
//  PokemonViewModel.swift
//  Pokemon
//
//  Created by 蘇健豪 on 2022/8/27.
//

import Foundation

class PokemonViewModel: ObservableObject {
    @Published var favritePokemons: [PokemonData] = []
}
