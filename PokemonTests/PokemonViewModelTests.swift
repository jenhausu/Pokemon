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
    
}
