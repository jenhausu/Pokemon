//
//  PokemonDataHTTPRequest.swift
//  Pokemon
//
//  Created by 蘇健豪 on 2022/8/27.
//

import Foundation
import NetworkKit

struct PokemonDataHTTPRequest: HTTPParamRequest {
    
    typealias RequestType = Request
    typealias ResponseType = Response
    
    struct Request: Encodable {
        let id: String
    }
    
    struct Response: Decodable {
        let id: Int
        let name: String
        let height: Int
        let weight: Int
        let sprites: Sprite
        let types: [ChildType]
        
        struct Sprite: Decodable {
            let front_default: String
        }
        
        struct ChildType: Decodable {
            let type: `Type`
            
            struct `Type`: Decodable {
                let name: String
                let url: String
            }
        }
    }
    
    var parameters: Request
    
    var baseURL: URL? {
        URL(string: "https://pokeapi.co/api/v2/")
    }
    
    var path: String {
        "pokemon/\(parameters.id)"
    }
    
    var method: NetworkKit.HTTPMethod {
        .get
    }
    
}
