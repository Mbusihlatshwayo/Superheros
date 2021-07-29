//
//  ParameterEncoding.swift
//  Superheros
//
//  Created by Mbusi Hlatshwayo on 7/27/21.
//

import Foundation

public typealias Parameters = [String:Any]

public protocol ParameterEncoder
{
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum NetworkError: String, Error
{
    case parametersNil = "Parameters were missing"
    case encodingFailed = "Parameter encoding failed"
    case missingURL = "URL is nil"
}
