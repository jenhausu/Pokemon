//
//  PokemonTableView.swift
//  Pokemon
//
//  Created by 蘇健豪 on 2022/8/27.
//

import SwiftUI
import NetworkKit

struct PokemonTableView: View {
        
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
                ForEach($viewModel.pokemonDatas) { data in
                    PokemonTableCellView(data: data)
                }
                ProgressView()
                    .onAppear {
                        Task {
                            do {
                                try await viewModel.getPokemonList(limit: 20,
                                                                   offset: viewModel.pokemonDatas.count + 20)
                            }
                        }
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
        .onAppear {
            Task {
                do {
                    try await viewModel.getPokemonList(limit: 20, offset: 0)
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
