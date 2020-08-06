import Vapor
import XCTest
@testable import LingoVapor

class LingoVaporTests: XCTestCase {

    func testInitialization() throws {
        var lingoProvider = LingoProvider(application: Application())
        lingoProvider.configuration = .init(defaultLocale: "en", localizationsDir: "Localizations")
        XCTAssertEqual(lingoProvider.configuration?.defaultLocale, "en")
    }
    
    static var allTests: [(String, (LingoVaporTests) -> () throws -> Void)] = [
        ("testInitialization", testInitialization),
    ]
    
}
