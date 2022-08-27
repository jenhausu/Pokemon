//
//  PokemonTableView.swift
//  Pokemon
//
//  Created by 蘇健豪 on 2022/8/27.
//

import SwiftUI

struct PokemonTableView: View {
    
    @State private var datas: [PokemonData] = SampleData.datas
    
    @State private var isFavoriteViewPresented: Bool = false
    
    @StateObject var viewModel = PokemonViewModel()
    
    var body: some View {
        NavigationView {
            ContentView()
        }
        .environmentObject(viewModel)
    }
    
    @ViewBuilder
    private func ContentView() -> some View {
        ScrollView {
            LazyVStack {
                ForEachWithIndex(datas) { index, element in
                    PokemonTableCellView(data: datas[index])
                }
            }
            .background(Color.gray)
        }
        .navigationTitle("Pokemon")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    isFavoriteViewPresented = true
                } label: {
                    Image(systemName: "heart.fill")
                        .tint(.red)
                }
                
            }
        }
        .background(
            NavigationLink(isActive: $isFavoriteViewPresented, destination: {
                FavoriteTableView(datas: viewModel.favritePokemons)
            }, label: {
                EmptyView()
            })
        )
    }
    
}

struct PokemonTableView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonTableView()
    }
}
