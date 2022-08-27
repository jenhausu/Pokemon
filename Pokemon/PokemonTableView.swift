//
//  PokemonTableView.swift
//  Pokemon
//
//  Created by 蘇健豪 on 2022/8/27.
//

import SwiftUI

struct PokemonTableView: View {
    
    @State private var datas: [PokemonData] = [PokemonData(PokemonId: "3",
                                                           name: "venusaur",
                                                           height: "20",
                                                           weight: "1000",
                                                           types: [PokemonData.PokemonType(name: "Grass"),
                                                                   PokemonData.PokemonType(name: "poison")],
                                                           pictureUrl: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/3.png")),
                                               PokemonData(PokemonId: "3",
                                                           name: "venusaur",
                                                           height: "20",
                                                           weight: "1000",
                                                           types: [PokemonData.PokemonType(name: "Grass"),
                                                                   PokemonData.PokemonType(name: "poison")],
                                                           pictureUrl: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/3.png"))]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(datas) { data in
                        PokemonTableCellView(data: data)
                    }
                }
                .background(Color.gray)
            }
            .navigationTitle("Pokemon")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "heart.fill")
                            .tint(.red)
                    }
                    
                }
            }
        }
    }
    
}

struct PokemonTableView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonTableView()
    }
}
