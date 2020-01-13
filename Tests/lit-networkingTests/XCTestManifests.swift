import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(lit_networkingTests.allTests),
    ]
}
#endif
