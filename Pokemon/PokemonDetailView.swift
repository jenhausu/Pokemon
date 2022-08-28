//
//  PokemonDetailView.swift
//  Pokemon
//
//  Created by 蘇健豪 on 2022/8/28.
//

import SwiftUI
import Kingfisher

struct PokemonDetailView: View {
    
    let data: PokemonData
    @ObservedObject var viewModel: PokemonViewModel
    
    @State var favorite: Bool = false
    
    var body: some View {
        VStack {
            KFImage(data.pictureUrl)
                .resizable()
                .frame(width: 188, height: 188)
                .scaledToFit()
                .background(Color.white)
                .cornerRadius(10)
            InformationSection(title: "編號", content: data.pokemonId)
            InformationSection(title: "名字", content: data.name)
            if let height = data.height {
                InformationSection(title: "身高", content: height)
            }
            if let weight = data.weight {
                InformationSection(title: "體重", content: weight)
            }
            InformationSection(title: "屬性", content: getTypeString(data: data))
            Spacer()
        }
        .navigationTitle(data.name)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
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
        }
        .onAppear {
            if viewModel.favritePokemons.contains(data) {
                favorite = true
            }
        }
        .onChange(of: favorite) { newValue in
            if newValue {
                viewModel.addFavorite(data)
            } else {
                viewModel.removeFavorite(data)
            }
        }
    }
    
    @ViewBuilder
    func InformationSection(title: String, content: String) -> some View {
        HStack {
            Text("\(title)：")
                .foregroundColor(.black)
            Text(content)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .frame(height: 15)
        .padding()
    }
    
    private func getTypeString(data: PokemonData) -> String {
        guard let types = data.types else { return "" }
        
        var typeString: String = ""
        for type in types {
            if typeString.isEmpty {
                typeString = type.name
            } else {
                typeString += " "
                typeString += type.name
            }
        }
        
        return typeString
    }
    
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(data: SampleData.data, viewModel: PokemonViewModel())
            .background(Color.gray)
        NavigationView {
            PokemonDetailView(data: SampleData.data, viewModel: PokemonViewModel())
        }
    }
}
