//
//  HTTPTask.swift
//  Superheros
//
//  Created by Mbusi Hlatshwayo on 7/27/21.
//

import Foundation

public typealias HTTPHeaders = [String:String]

public enum HTTPTask
{
    case request
    case requestParameters(bodyParameters: Parameters?, urlParameters: Parameters?)
    case requestParametersAndHeaders(bodyParameters: Parameters?, urlParameters: Parameters?, headers: HTTPHeaders?)
}
