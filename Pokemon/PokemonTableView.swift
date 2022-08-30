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
    
    @StateObject var viewModel = PokemonViewModel(httpClient: HTTPClient())
    @StateObject var routeManager = RouteManager()
        
    var body: some View {
        NavigationView {
            ContentView()
        }
        .environmentObject(routeManager)
    }
    
    @ViewBuilder
    private func ContentView() -> some View {
        ScrollView {
            LazyVStack {
                ForEach($viewModel.pokemonDatas) { data in
                    PokemonTableCellView(data: data, viewModel: viewModel)
                }
                ProgressView()
                    .onAppear {
                        Task {
                            do {
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
                FavoriteTableView(viewModel: viewModel)
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
    }
    
}

struct PokemonTableView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonTableView()
    }
}
