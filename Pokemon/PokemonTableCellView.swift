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
        }
        .padding()
    }
}

struct PokemonTableCellView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonTableCellView(data: PokemonData(PokemonId: "3",
                                               name: "venusaur",
                                               height: "20",
                                               weight: "1000",
                                               types: [PokemonData.PokemonType(name: "Grass"),
                                                       PokemonData.PokemonType(name: "poison")],
                                               pictureUrl: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/3.png")))
        .previewLayout(.sizeThatFits)
    }
}
