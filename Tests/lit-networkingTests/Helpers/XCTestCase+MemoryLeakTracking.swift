//
//  XCTestCase+MemoryLeakTracking.swift
//  EssentialFeedTests
//
//  Created by Mendy Edri on 04/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import XCTest

extension XCTestCase {
    public func trackMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
         addTeardownBlock { [weak instance] in
             XCTAssertNil(instance, "Instance should have been deallocated, Potential memory leak", file: file, line: line)
         }
    }
}
