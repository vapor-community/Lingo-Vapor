import Vapor
import XCTest
@testable import LingoVapor

class LingoVaporTests: XCTestCase {

    func testInitialization() throws {
        let lingoProvider = LingoProvider(defaultLocale: "en")
        XCTAssertEqual(lingoProvider.defaultLocale, "en")
    }
    
    static var allTests: [(String, (LingoVaporTests) -> () throws -> Void)] = [
        ("testInitialization", testInitialization),
    ]
    
}
