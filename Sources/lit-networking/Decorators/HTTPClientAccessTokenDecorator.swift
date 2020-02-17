//
//  HTTPClientAccessTokenDecorator.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 01/01/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation

public protocol AccessTokenAdapter {
    func requestAccessToken(_ completion: @escaping (Result<String, Error>) -> Void)
}

public final class HTTPClientAccessTokenDecorator: HTTPClientDecorator {
    
    public enum Error: Swift.Error {
        case authFailed
        case invalidData
        case connectivity
        case badURL
    }
    
    struct UnexpectedValueRepresentation: Swift.Error {}
    
    private let authKey = "Authorization"
    
    private var client: HTTPClient
    private var tokenAdapter: AccessTokenAdapter
    
    public init(http client: HTTPClient, tokenAdapter: AccessTokenAdapter) {
        self.client = client
        self.tokenAdapter = tokenAdapter
    }
    
    public func get(from url: URL, method: HTTPMethod, headers: [String : String]?, completion: @escaping (HTTPClient.Result) -> Void) {
        #warning("TODO: make it serial")
        tokenAdapter.requestAccessToken { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .failure(error):
                completion(.failure(error))
                
            case let .success(token):
                #warning("TODO: save the requests in queue, in order to have multiple request support")
                let decoratedHeaders = headers?.appendAuth(token: token)
                self.client.get(from: url, method: method, headers: decoratedHeaders, completion: completion)
            }
        }
    }
    
    public func get(with request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) {
        guard let url = request.url else { return completion ( .failure(Error.badURL) )}
        get(from: url, method: request.httpMethodType, headers: request.allHTTPHeaderFields, completion: completion)
    }
}

private extension Dictionary where Key == String, Value == String {
    private var authKey: String {
        return "Authorization"
    }
    
    private var authValueType: String {
        return "Bearer"
    }
    
    func appendAuth(token: String) -> [String: String] {
        var decorated = self
        decorated[authKey] = "\(authValueType) \(token)"
        return decorated
    }
}
