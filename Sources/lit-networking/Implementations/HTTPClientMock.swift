//
//  ChatHTTPClientMock.swift
//  ChatHTTPLoaderTests
//
//  Created by Mendy Edri on 05/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

public class HTTPClientMock: HTTPClient {
    
    private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
    
    public init() {}
    
    // MARK: Implementation
    
    public func get(from url: URL, method: HTTPMethod, headers: [String: String]?, body: [String: String]?, completion: @escaping (HTTPClient.Result) -> Void) {
        messages.append((url, completion))
    }
    
    public func get(with request: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        messages.append((request.url!, completion))
    }
    
    // MARK: Helpers
    public var requestedURLs: [URL] {
        return messages.map { $0.url }
    }
    
    // MARK: Mock
    
    public func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    public func complete(withSatus code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(url: messages[index].url,
                                       statusCode: code,
                                       httpVersion: nil,
                                       headerFields: nil)!
        
        messages[index].completion(.success((data, response)))
    }
}

