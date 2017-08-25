import Vapor
import XCTest
@testable import LingoProvider

class LingoProviderTests: XCTestCase {

    func testInitialization() throws {
        var config = try Config()
        try config.set("lingo.localizationsDir", "/")
        try config.set("lingo.defaultLocale", "en")
        try config.addProvider(LingoProvider.Provider.self)
        
        let drop = try Droplet(config)
        
        XCTAssertEqual(drop.lingo.defaultLocale, "en")
    }
    
    static var allTests: [(String, (LingoProviderTests) -> () throws -> Void)] = [
        ("testInitialization", testInitialization),
    ]
    
}
