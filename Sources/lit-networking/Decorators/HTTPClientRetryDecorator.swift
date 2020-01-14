//
//  HTTPClientRetryDecorator.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 01/01/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation

public class HTTPClientRetryDecorator: HTTPClientDecorator {
    
    private let httpClient: HTTPClient
    private var maxAttempts = 5
    private var attempts = 0
    public var onRetry: (() -> Void)?
    
    public var retryable: Retryable?
    
    private var request: (url: URL, method: HTTPMethod, headers: [String: String]?, body: [String: String]?, completion: ((HTTPClientRetryDecorator.Result) -> Void))?
    
    public init(http client: HTTPClient, retryable: Retryable) {
        self.httpClient = client
        self.request = nil
        self.retryable = retryable
    }
    
    public func get(from url: URL, method: HTTPMethod, headers: [String : String]?, body: [String : String]?, completion: @escaping (HTTPClientRetryDecorator.Result) -> Void) {
        
        request = (url, method, headers, body, completion)
        
        self.retryable?.setAction { [weak self] in
            guard let request = self?.request else { return }
            self?.get(from: request.url,
                      method: request.method,
                      headers: request.headers,
                      body: request.body,
                      completion: request.completion)
        }
        
        httpClient.get(from: url, method: method, headers: headers, body: body) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure:
                if self.retryable?.retry() == false {
                  return completion(result)
                }
            case .success:
                completion(result)
            }
        }
    }
    
    // Mark: Helpers
    
    private func clientCall(from url: URL, method: HTTPMethod, headers: [String: String]?, body: [String: String]?, completion: @escaping (HTTPClientRetryDecorator.Result) -> Void) {
        
        httpClient.get(from: url, method: method, headers: headers, body: body) { [weak self] result in
            guard let self = self else { return }
            
            completion(self.handle(client: result))
        }
    }
    
    private func handle(client result: HTTPClientRetryDecorator.Result) -> HTTPClientRetryDecorator.Result {
        if case let .failure(error) = result, retry() == false {
            return .failure(error)
        }
        return result
    }
    
    private func retry() -> Bool {
        guard canRetry() == true, let request = request else { return false }
        attempts += 1
        get(from: request.url, method: request.method, headers: request.headers, body: request.body, completion: request.completion)
        onRetry?()
        
        return true
    }
    
    private func canRetry() -> Bool {
        return attempts < maxAttempts
    }
}