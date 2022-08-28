//
//  PokemonTableView.swift
//  Pokemon
//
//  Created by 蘇健豪 on 2022/8/27.
//

import SwiftUI
import NetworkKit

struct PokemonTableView: View {
        
    @State private var isLoading: Bool = false
    
    @State private var isFavoriteViewPresented: Bool = false
    
    @StateObject var viewModel = PokemonViewModel()
    @StateObject var routeManager = RouteManager()
        
    var body: some View {
        NavigationView {
            ContentView()
        }
        .environmentObject(viewModel)
        .environmentObject(routeManager)
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
                                guard !viewModel.pokemonDatas.isEmpty else { return }
                                guard !isLoading else { return }
                                isLoading = true
                                try await viewModel.getPokemonList(limit: 20,
                                                                   offset: viewModel.pokemonDatas.count)
                                isLoading = false
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
        .background(
            NavigationLink(isActive: $routeManager.isDetailViewPresented, destination: {
                PokemonDetailView(data: routeManager.selectedPokemon, viewModel: viewModel)
            }, label: {
                EmptyView()
            })
        )
        .onAppear {
            Task {
                do {
                    isLoading = true
                    try await viewModel.getPokemonList(limit: 20, offset: 0)
                    isLoading = false
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
