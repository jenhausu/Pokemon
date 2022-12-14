//
//  FavoriteTableCellView.swift
//  Pokemon
//
//  Created by 蘇健豪 on 2022/8/28.
//

import SwiftUI
import Kingfisher

struct FavoriteTableCellView: View {
    
    let data: PokemonData
    @Binding var prepareToRemoveData: [PokemonData]
    @ObservedObject var viewModel: PokemonViewModel
    
    @State private var favorite: Bool = false
    
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
                    prepareToRemoveData.append(data)
                } else {
                    prepareToRemoveData = prepareToRemoveData.filter { $0.id != data.id }
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
        }
    }
}

struct FavoriteTableCellView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteTableCellView(data: SampleData.data, prepareToRemoveData: .constant([]), viewModel: PokemonViewModel())
    }
}
