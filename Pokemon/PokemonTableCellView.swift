//
//  PokemonTableCellView.swift
//  Pokemon
//
//  Created by 蘇健豪 on 2022/8/27.
//

import SwiftUI
import Kingfisher
import NetworkKit

struct PokemonTableCellView: View {
    
    @Binding var data: PokemonData
    @ObservedObject var viewModel: PokemonViewModel
    
    @State private var favorite: Bool = false
    @State private var dataDidLoad: Bool = false
    
    @EnvironmentObject var routeManager: RouteManager

    var body: some View {
        HStack {
            KFImage(data.pictureUrl)
                .placeholder {
                    ProgressView()
                }
                .resizable()
                .scaledToFill()
                .background(Color.white)
                .frame(width: 80, height: 80)
                .cornerRadius(10)
            VStack(alignment: .leading) {
                if let id = data.pokemonId {
                    Text("編號: \(id)")
                }
                Spacer()
                if let name = data.name {
                    Text("名字: \(name)")
                }
            }
            .padding()
            Spacer()
            Button {
                if favorite {
                    viewModel.favritePokemons = viewModel.favritePokemons.filter { $0.id != data.id }
                } else {
                    viewModel.favritePokemons.append(data)
                }
                
                favorite.toggle()
            } label: {
                if favorite {
                    Image(systemName: "heart.fill")
                } else {
                    Image(systemName: "heart")
                }
            }
            .tint(.red)
        }
        .padding()
        .onAppear {
            if viewModel.favritePokemons.contains(data) {
                favorite = true
            } else {
                favorite = false
            }
            
            Task {
                if dataDidLoad == false {
                    dataDidLoad = true
                    do {
                        let response = try await viewModel.getPokemon(id: data.pokemonId)
                        data.height = "\(response.height)"
                        data.weight = "\(response.weight)"
                        data.pictureUrl = URL(string: response.sprites.front_default)
                        data.types = response.types.map { PokemonData.PokemonType(name: $0.type.name) }
                    }
                }
            }
        }
        .onTapGesture {
            routeManager.selectedPokemon = data
            routeManager.isDetailViewPresented = true
        }
    }
    
}

struct PokemonTableCellView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonTableCellView(data: .constant(SampleData.data), viewModel: PokemonViewModel())
        .previewLayout(.sizeThatFits)
    }
}
