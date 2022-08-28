//
//  PokemonViewModelTests.swift
//  PokemonTests
//
//  Created by 蘇健豪 on 2022/8/28.
//

import XCTest
@testable import Pokemon

final class PokemonViewModelTests: XCTestCase {
    
    let sut = PokemonViewModel()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut.pokemonDatas = []
        sut.favritePokemons = []
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut.pokemonDatas = []
        sut.favritePokemons = []
    }
    
    @MainActor
    func testGetGokemonListData_Once() async {
        do {
            try await sut.getPokemonList(limit: 20, offset: 0)
        } catch {
            XCTAssertThrowsError(error.localizedDescription)
        }
        
        XCTAssertEqual(sut.pokemonDatas.count, 20)
    }
    
    @MainActor
    func testGetGokemonListData_ThreeTime() async {
        do {
            try await sut.getPokemonList(limit: 20, offset: 0)
            try await sut.getPokemonList(limit: 20, offset: sut.pokemonDatas.count)
            try await sut.getPokemonList(limit: 20, offset: sut.pokemonDatas.count)
        } catch {
            XCTAssertThrowsError(error.localizedDescription)
        }
        
        XCTAssertEqual(sut.pokemonDatas.count, 60)
    }
    
    @MainActor
    func testGetGokemonListData_DataOrderAscending() async {
        do {
            try await sut.getPokemonList(limit: 20, offset: 0)
            try await sut.getPokemonList(limit: 20, offset: sut.pokemonDatas.count)
            try await sut.getPokemonList(limit: 20, offset: sut.pokemonDatas.count)
            try await sut.getPokemonList(limit: 20, offset: sut.pokemonDatas.count)
            try await sut.getPokemonList(limit: 20, offset: sut.pokemonDatas.count)
        } catch {
            XCTAssertThrowsError(error.localizedDescription)
        }
        
        var lastDataId: Int = 0
        for data in sut.pokemonDatas {
            if let id = Int(data.pokemonId) {
                XCTAssertEqual(lastDataId + 1, id)
                lastDataId = id
            }
        }
    }
    
    // MARK: - Favorite
    
    func testAddFavorite_twoItem_countTwo() {
        let pokemon = PokemonData(pokemonId: "1", name: "aaa")
        sut.addFavorite(pokemon)
        
        let pokemon2 = PokemonData(pokemonId: "2", name: "bbb")
        sut.addFavorite(pokemon2)
        
        XCTAssertEqual(sut.favritePokemons.count, 2)
    }
    
    func testFavorite_addRedundantItem_countOne() {
        let pokemon = PokemonData(pokemonId: "1", name: "aaa")
        sut.addFavorite(pokemon)
        sut.addFavorite(pokemon)
        
        XCTAssertEqual(sut.favritePokemons.count, 1)
    }
    
    func testRemoveFavorite() {
        let pokemon = PokemonData(pokemonId: "1", name: "aaa")
        sut.addFavorite(pokemon)
        
        let pokemon2 = PokemonData(pokemonId: "2", name: "bbb")
        sut.addFavorite(pokemon2)
        
        sut.removeFavorite(pokemon)
        
        XCTAssertEqual(sut.favritePokemons.count, 1)
        XCTAssertEqual(sut.favritePokemons, [pokemon2])
    }
    
    func testRemoveFavorite_notExitItem_noCrash() {
        let pokemon = PokemonData(pokemonId: "1", name: "aaa")
        sut.addFavorite(pokemon)
        
        let pokemon2 = PokemonData(pokemonId: "2", name: "bbb")
        sut.addFavorite(pokemon2)
        
        let pokemon3 = PokemonData(pokemonId: "3", name: "ccc")
        sut.removeFavorite(pokemon3)
        
        XCTAssertEqual(sut.favritePokemons.count, 2)
    }
    
}
