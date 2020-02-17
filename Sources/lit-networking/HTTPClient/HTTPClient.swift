//
//  ChatHTTPClient.swift
//  ChatHTTPLoader
//
//  Created by Mendy Edri on 30/10/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

/** All supported http request methods */
public enum HTTPMethod: String {
    case GET
    case POST
    case DELETE
    case UPDATE
}

public extension URLRequest {
    mutating func httpMethod(_ method: HTTPMethod) {
        self.httpMethod = method.rawValue
    }
    
    var httpMethodType: HTTPMethod {
        return self.httpMethod?.httpType ?? .GET
    }
}

private extension String {
    var httpType: HTTPMethod {
        switch self {
        case HTTPMethod.GET.rawValue:
            return .GET
        
        case HTTPMethod.POST.rawValue:
            return .POST
            
        case HTTPMethod.DELETE.rawValue:
            return .DELETE
            
        case HTTPMethod.UPDATE.rawValue:
            return .UPDATE
        
        default:
            return .GET
        }
    }
}

/** Protocol for chat requests - STS, STS-metadata, Identity-Store */
public protocol HTTPClient {
    
    /** HTTP response enum type, represents ChatHTTPClient requests' response object */
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    /** Generic request from URL function */
    func get(with request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void)
}

/** Protocol methods overloading. Instead of requires every implementation to have 3 `get()` methods, it requires the basic, and the protocol with this extension exposed 2 more usefull methods. */
extension HTTPClient {
    /** Overloaded request - Gets URL and Completion as params  */
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        get(from: url, method: .GET, completion: completion)
    }
    
    /** Overloaded request - Gets URL, http method and Completion as params  */
    public func get(from url: URL, method: HTTPMethod, completion: @escaping (HTTPClient.Result) -> Void) {
        get(from: url, method: .GET, headers: nil, completion: completion)
    }
   
    /** Overloaded request - Gets URL, http method, headers and Completion as params  */
    public func get(from url: URL, method: HTTPMethod, headers: [String: String]?, body: [String: String]? = nil, completion: @escaping (Result) -> Void) {
        let request = buildRequest(from: url, method: method, headers: headers, bodyDictionary: body)
        get(with: request, completion: completion)
    }
       
    func get(from url: URL, method: HTTPMethod, headers: [String: String]?, body: Data?, completion: @escaping (Result) -> Void) {
        let request = buildRequest(from: url, method: method, headers: headers, body: body)
        get(with: request, completion: completion)
    }
    
    
    private func buildRequest(from url: URL, method: HTTPMethod = .GET, headers: [String: String]? = nil, body: Data? = nil, bodyDictionary: [String: String]? = nil) -> URLRequest {
        let request = URLRequest(url: url, method: method, headers: headers, body: body)

        return request
    }
}
