//
//  Router.swift
//  Superheros
//
//  Created by Mbusi Hlatshwayo on 7/27/21.
//

import Foundation

class Router<EndPoint: EndPointType>: NetworkRouter
{
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    {
        let session = URLSession.shared
        do
        {
            let request = try buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        }
        catch
        {
            completion(nil, nil, error)
        }
        task?.resume()
    }
    
    func cancel()
    {
        task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest
    {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path), cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: Constants.kTimeoutInterval)
        request.httpMethod = route.httpMethod.rawValue
        do
        {
            switch route.task {
            case .request:
                request.setValue(Constants.kJSONContentType, forHTTPHeaderField: Constants.kContentTypeHeader)
            case .requestParameters(let bodyParameters, let urlParameters):
                try configureParameters(bodyParameters: bodyParameters,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters, let urlParameters, let additionalHeaders):
                addAdditionalHeaders(additionalHeaders, request: &request)
                try configureParameters(bodyParameters: bodyParameters,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        }
        catch
        {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws
    {
        do
        {
            if let bodyParameters = bodyParameters
            {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            if let urlParameters = urlParameters
            {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        }
        catch
        {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest)
    {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers
        {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
