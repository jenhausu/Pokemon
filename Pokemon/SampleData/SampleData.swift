//
//  SampleData.swift
//  Pokemon
//
//  Created by 蘇健豪 on 2022/8/27.
//

import Foundation

struct SampleData {
    static let data = PokemonData(pokemonId: "3",
                                  name: "venusaur",
                                  height: "20",
                                  weight: "1000",
                                  types: [PokemonData.PokemonType(name: "Grass"),
                                          PokemonData.PokemonType(name: "poison")],
                                  pictureUrl: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/3.png"))
    
    static let datas = [PokemonData(pokemonId: "1",
                                    name: "bulbasaur",
                                    height: "7",
                                    weight: "69",
                                    types: [PokemonData.PokemonType(name: "Grass"),
                                            PokemonData.PokemonType(name: "poison")],
                                    pictureUrl: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")),
                        PokemonData(pokemonId: "2",
                                    name: "ivysaur",
                                    height: "10",
                                    weight: "130",
                                    types: [PokemonData.PokemonType(name: "Grass"),
                                            PokemonData.PokemonType(name: "poison")],
                                    pictureUrl: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png")),
                        PokemonData(pokemonId: "3",
                                    name: "venusaur",
                                    height: "20",
                                    weight: "1000",
                                    types: [PokemonData.PokemonType(name: "Grass"),
                                            PokemonData.PokemonType(name: "poison")],
                                    pictureUrl: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/3.png"))]
}
