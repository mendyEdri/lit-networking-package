//
//  SharedTestsHelper.swift
//  EssentialFeedTests
//
//  Created by Mendy Edri on 19/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

internal func anyNSError() -> NSError {
    return NSError(domain: "any domain", code: 0)
}

internal func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}
