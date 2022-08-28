//
//  FavoriteTableView.swift
//  Pokemon
//
//  Created by 蘇健豪 on 2022/8/27.
//

import SwiftUI

struct FavoriteTableView: View {
    
    let datas: [PokemonData]
    
    @ObservedObject var viewModel: PokemonViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEachWithIndex(datas) { index, element in
                    FavoriteTableCellView(data: .constant(datas[index]), viewModel: viewModel)
                }
            }
            .background(Color.gray)
        }
        .navigationTitle("Favorite")
    }
}

struct FavoriteTableView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteTableView(datas: [SampleData.data], viewModel: PokemonViewModel())
    }
}
