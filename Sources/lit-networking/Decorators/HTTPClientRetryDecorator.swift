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
    public var onRetry: (() -> Void)?
    
    public var retryable: Retryable?
        
    public init(http client: HTTPClient, retryable: Retryable) {
        self.httpClient = client
        self.retryable = retryable
    }
        
    public func get(with request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) {
        
        self.retryable?.setAction { [weak self] in
            self?.get(with: request, completion: completion)
        }
        
        httpClient.get(with: request) { [weak self] result in
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
    
    private func handle(client result: HTTPClientRetryDecorator.Result) -> HTTPClientRetryDecorator.Result {
        if case let .failure(error) = result, retry() == false {
            return .failure(error)
        }
        return result
    }
    
    private func retry() -> Bool {
        return retryable?.retry() ?? false
    }
}
