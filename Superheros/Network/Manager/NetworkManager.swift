//
//  NetworkManager.swift
//  Superheros
//
//  Created by Mbusi Hlatshwayo on 7/27/21.
//

import UIKit

enum NetworkEnvironment
{
    case staging
    case integration
    case production
}

enum NetworkResponse: String
{
    case success
    case authenticationError = "You need to be authenticated"
    case badRequest = "Bad Request"
    case deprecated = "The url you requested is deprecated"
    case failed = "Network request failed"
    case noData = "Response returned with no data to decode"
    case unableToDecode = "Decoding error"
    case tryAgain = "Check your connection and try again"
}

enum ResultType<String>
{
    case success
    case failure(String)
}

class NetworkManager
{
    static let environment: NetworkEnvironment = .production
    static let MarvelPublicApiKey = Constants.kMarvelPublicAPIKey
    static let MarvelPrivateApiKey = Constants.kMarvelPrivateAPIKey
    private let router = Router<MarvelHeroesApi>()
    static let shared = NetworkManager()
    let cache = NSCache<NSString, UIImage>()
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> ResultType<String>
    {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.deprecated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    func getHeroes(offset: Int, publicKey: String, completion: @escaping (_ movie: [Character]?,_ error: String?)->())
    {
        let timeStamp: String = String(Date().timeIntervalSince1970)
        let hash = ("\(timeStamp)\(NetworkManager.MarvelPrivateApiKey)\(NetworkManager.MarvelPublicApiKey)").MD5
        router.request(.allCharacters(offset: offset, timeStamp: timeStamp, publicKey: publicKey, hash: hash)) { data, response, error in
            
            if error != nil
            {
                completion(nil, NetworkResponse.tryAgain.rawValue)
            }
            
            if let response = response as? HTTPURLResponse
            {
                let result = self.handleNetworkResponse(response)
                switch result
                {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do
                    {
                        let apiResponse = try JSONDecoder().decode(CharacterResponse.self, from: responseData)
                        completion(apiResponse.data?.results,nil)
                    }
                    catch
                    {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }

    func getHeroesWithName(offset: Int, nameStartingWith: String, completion: @escaping (_ movie: [Character]?,_ error: String?)->())
    {
        let timeStamp: String = String(Date().timeIntervalSince1970)
        let hash = ("\(timeStamp)\(NetworkManager.MarvelPrivateApiKey)\(NetworkManager.MarvelPublicApiKey)").MD5
        router.request(.charactersWithName(offset: offset, nameStartsWith: nameStartingWith, timeStamp: timeStamp, publicKey: NetworkManager.MarvelPublicApiKey, hash: hash)) { data, response, error in
            if error != nil
            {
                completion(nil, NetworkResponse.tryAgain.rawValue)
            }
            
            if let response = response as? HTTPURLResponse
            {
                let result = self.handleNetworkResponse(response)
                switch result
                {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do
                    {
                        let apiResponse = try JSONDecoder().decode(CharacterResponse.self, from: responseData)
                        completion(apiResponse.data?.results,nil)
                    }
                    catch
                    {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
}

