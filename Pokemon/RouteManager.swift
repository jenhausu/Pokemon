//
//  RouteManager.swift
//  Pokemon
//
//  Created by 蘇健豪 on 2022/8/28.
//

import Foundation

class RouteManager: ObservableObject {
    @Published var selectedPokemon: PokemonData = SampleData.data
    @Published var isDetailViewPresented: Bool = false
}
