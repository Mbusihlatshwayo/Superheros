//
//  URLParameterEncoder.swift
//  Superheros
//
//  Created by Mbusi Hlatshwayo on 7/27/21.
//

import Foundation

public struct URLParameterEncoder: ParameterEncoder
{
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
    {
        
        guard let url = urlRequest.url else {
            throw NetworkError.missingURL
        }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), parameters.isEmpty == false
        {
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters
            {
                let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
        if urlRequest.value(forHTTPHeaderField: Constants.kContentTypeHeader) == nil
        {
            urlRequest.setValue(Constants.kDefaultContentType, forHTTPHeaderField: Constants.kContentTypeHeader)
        }
    }
}
