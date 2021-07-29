//
//  MarvelHeroesApi.swift
//  Superheros
//
//  Created by Mbusi Hlatshwayo on 7/27/21.
//

import Foundation

enum MarvelHeroesApi
{
    case allCharacters(offset: Int, timeStamp: String, publicKey: String, hash: String)
    case charactersWithName(offset: Int, nameStartsWith: String, timeStamp: String, publicKey: String, hash: String)
}

extension MarvelHeroesApi: EndPointType
{
    var environmentBaseURL : String
    {
        switch NetworkManager.environment
        {
        case .production, .integration, .staging: return Constants.kMarvelDefaultBaseURL
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self
        {
        case .allCharacters, .charactersWithName:
            return "characters"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .allCharacters(let offset, let timeStamp, let publicKey, let hash):
            return .requestParameters(bodyParameters: nil,
                                      urlParameters: ["offset": offset,
                                                      "limit": 100,
                                                      "ts": timeStamp,
                                                      "apikey": publicKey,
                                                      "hash": hash])
        case .charactersWithName(let offset, let nameStartsWith, let timeStamp, let publicKey, let hash):
            return .requestParameters(bodyParameters: nil,
                                      urlParameters: ["offset": offset,
                                                      "nameStartsWith": nameStartsWith,
                                                      "limit": 100,
                                                      "ts": timeStamp,
                                                      "apikey": publicKey,
                                                      "hash": hash])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}


