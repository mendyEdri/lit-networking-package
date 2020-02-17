//
//  File.swift
//  
//
//  Created by Mendy Edri on 17/02/2020.
//

import Foundation

extension URLRequest {
    static func builder(url: URL, method: HTTPMethod, headers: [String: String]?, bodyData: Data?, bodyMap: [String: String]?) -> URLRequest {
         if let data = bodyData {
             return URLRequest(url: url, method: method, headers: headers, body: data)
         }
         
         return URLRequest(url: url, method: method, headers: headers, body: bodyMap)
     }
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
