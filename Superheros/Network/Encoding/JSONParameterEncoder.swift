//
//  JSONParameterEncoder.swift
//  Superheros
//
//  Created by Mbusi Hlatshwayo on 7/27/21.
//

import Foundation

public struct JSONParameterEncoder: ParameterEncoder
{
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
    {
        do
        {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            
            if urlRequest.value(forHTTPHeaderField: Constants.kContentTypeHeader) == nil
            {
                urlRequest.setValue(Constants.kJSONContentType, forHTTPHeaderField: Constants.kContentTypeHeader)
            }
        }
        catch
        {
            throw NetworkError.encodingFailed
        }
    }
}
