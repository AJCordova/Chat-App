import XCTest
@testable import Chat_App

final class Chat_AppTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Chat_App().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
