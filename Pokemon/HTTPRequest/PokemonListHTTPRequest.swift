//
//  PokemonListHTTPRequest.swift
//  Pokemon
//
//  Created by 蘇健豪 on 2022/8/27.
//

import Foundation
import NetworkKit

struct PokemonListHTTPRequest: HTTPParamRequest {
    
    typealias RequestType = Request
    typealias ResponseType = Response
    
    struct Request: Encodable {
        let limit: Int
        let offset: Int
    }
    
    struct Response: Decodable {
        let results: [Result]
        
        struct Result: Decodable {
            let name: String
            let url: String
        }
    }
    
    var parameters: Request
    
    var baseURL: URL? {
        URL(string: "https://pokeapi.co/api/v2/")
    }
    
    var path: String {
        "pokemon"
    }
    
    var method: NetworkKit.HTTPMethod {
        .get
    }
    
}
