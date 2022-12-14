//
//  PokemonViewModelTests.swift
//  PokemonTests
//
//  Created by 蘇健豪 on 2022/8/28.
//

import XCTest
@testable import Pokemon
@testable import NetworkKit

final class PokemonViewModelTests: XCTestCase {
    
    var sut: PokemonViewModel! = PokemonViewModel(httpClient: HTTPClientStub())
    
    weak var weakSUT: PokemonViewModel?
    
    override func setUp() {
        weakSUT = sut
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
        XCTAssertNil(weakSUT)
    }
    
    // MARK: - GetPokemonListData
    
    func testGetPokemonListData_Error_ThrowError() async {
        var returnError: (any Error)?
        let sut = PokemonViewModel(httpClient: HTTPClientFailedStub())
        
        do {
            _ = try await sut.getPokemonList(limit: 20, offset: 0)
        } catch {
            returnError = error
        }
        
        XCTAssertEqual(returnError as? StubError, StubError.errorReturn)
    }
    
    func testGetPokemonListData_Once() async {
        do {
            try await sut.getPokemonList(limit: 20, offset: 0)
        } catch {
            XCTAssertThrowsError(error.localizedDescription)
        }
        
        XCTAssertEqual(sut.pokemonDatas.count, 20)
    }
    
    func testGetPokemonListData_ThreeTime() async {
        do {
            try await sut.getPokemonList(limit: 20, offset: 0)
            try await sut.getPokemonList(limit: 20, offset: sut.pokemonDatas.count)
            try await sut.getPokemonList(limit: 20, offset: sut.pokemonDatas.count)
        } catch {
            XCTAssertThrowsError(error.localizedDescription)
        }
        
        XCTAssertEqual(sut.pokemonDatas.count, 60)
    }
    
    func testGetPokemonListData_SameParam_NoReduntantItemAppend() async {
        do {
            try await sut.getPokemonList(limit: 20, offset: 0)
            try await sut.getPokemonList(limit: 20, offset: 20)
            try await sut.getPokemonList(limit: 20, offset: 20)
        } catch {
            XCTAssertThrowsError(error.localizedDescription)
        }
        
        XCTAssertEqual(sut.pokemonDatas.count, 40)
    }
    
    func testGetPokemonListData_DataOrderAscending() async {
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
        
        XCTAssertEqual(sut.pokemonDatas.count, 100)
    }
    
    // MARK: - GetPokemonData
    
    func testGetPokemonData_success() async {
        let sut = PokemonViewModel(httpClient: HTTPClientStub())
        var response: PokemonDataHTTPRequest.Response?
        
        do {
            response = try await sut.getPokemon(id: "1")
        } catch {
            XCTAssertThrowsError(error.localizedDescription)
        }
        
        XCTAssertTrue(response != nil)
    }
    
    func testGetPokemonData_Error_ThrowError() async {
        var returnError: (any Error)?
        let sut = PokemonViewModel(httpClient: HTTPClientFailedStub())
        
        do {
            _ = try await sut.getPokemon(id: "")
        } catch {
            returnError = error
        }
        
        XCTAssertEqual(returnError as? StubError, StubError.errorReturn)
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

enum StubError: Error {
    case errorReturn
    case notExpectRequestType
}

class HTTPClientFailedStub: HTTPClientProtocol {
    func send<Req>(_ request: Req) async -> Result<Req.ResponseType, Error> where Req : NetworkKit.HTTPRequest {
        await self.send(request, handlers: [])
    }
    
    func send<Req: HTTPRequest>(_ request: Req, handlers: [ResponseHandler]) async -> Result<Req.ResponseType, Error> {
        .failure(StubError.errorReturn)
    }
}

class HTTPClientStub: HTTPClientProtocol {
    
    func send<Req>(_ request: Req) async -> Result<Req.ResponseType, Error> where Req : NetworkKit.HTTPRequest {
        await self.send(request, handlers: [])
    }
    
    func send<Req: HTTPRequest>(_ request: Req, handlers: [ResponseHandler]) async -> Result<Req.ResponseType, Error> {
        if let request = request as? PokemonListHTTPRequest {
            let limit = request.parameters.limit
            let offset = request.parameters.offset
            
            var results: [PokemonListHTTPRequest.Response.Result] = []
            for index in (offset + 1)...(offset + limit) {
                let result = PokemonListHTTPRequest.Response.Result(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/\(index)/")
                results.append(result)
            }
            let response = PokemonListHTTPRequest.Response(results: results)
            
            return .success(response as! Req.ResponseType)
        } else if let _ = request as? PokemonDataHTTPRequest {
            let response = PokemonDataHTTPRequest.Response(
                id: 1,
                name: "",
                height: 100,
                weight: 100,
                sprites: PokemonDataHTTPRequest.Response.Sprite(front_default: ""),
                types: [PokemonDataHTTPRequest.Response.ChildType(type: PokemonDataHTTPRequest.Response.ChildType.TypeStruct(name: "", url: ""))])
            
            return .success(response as! Req.ResponseType)
        } else {
            return .failure(StubError.notExpectRequestType)
        }
    }
    
}
