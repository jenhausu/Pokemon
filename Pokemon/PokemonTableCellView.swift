//
//  PokemonTableCellView.swift
//  Pokemon
//
//  Created by 蘇健豪 on 2022/8/27.
//

import SwiftUI
import Kingfisher

struct PokemonTableCellView: View {
    
    let data: PokemonData
    
    @State var favorite: Bool = false
    
    @EnvironmentObject var viewModel: PokemonViewModel
    
    var body: some View {
        HStack {
            KFImage(data.pictureUrl)
                .resizable()
                .scaledToFill()
                .background(Color.white)
                .frame(width: 80, height: 80)
                .cornerRadius(10)
            VStack(alignment: .leading) {
                HStack {
                    Text("id: \(data.PokemonId)")
                    Text("name: \(data.name)")
                }
                Text("height: \(data.height)")
                Text("weight: \(data.weight)")
            }
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
        }
    }
    
}

struct PokemonTableCellView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonTableCellView(data: SampleData.data)
        .previewLayout(.sizeThatFits)
    }
}
