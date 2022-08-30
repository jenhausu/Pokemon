//
//  FavoriteTableView.swift
//  Pokemon
//
//  Created by 蘇健豪 on 2022/8/27.
//

import SwiftUI

struct FavoriteTableView: View {
    
    @ObservedObject var viewModel: PokemonViewModel
    @State private var prepareToRemoveDatas: [PokemonData] = []
        
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.favritePokemons) { element in
                    FavoriteTableCellView(data: element, prepareToRemoveData: $prepareToRemoveDatas, viewModel: viewModel)
                }
            }
            .background(Color.gray)
            .animation(.easeInOut, value: viewModel.favritePokemons)
        }
        .navigationTitle("Favorite")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                    for data in prepareToRemoveDatas {
                        viewModel.favritePokemons = viewModel.favritePokemons.filter { $0.pokemonId != data.pokemonId }
                    }
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Pokemon")
                    }
                }

            }
        }
    }
}

struct FavoriteTableView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteTableView(viewModel: PokemonViewModel())
    }
}
