import Vapor
import XCTest
@testable import LingoVapor

class LingoVaporTests: XCTestCase {

    private var application: Application!

    override func setUp() {
        super.setUp()
        self.application = Application()
    }

    override func tearDown() {
        self.application.shutdown()
        super.tearDown()
    }

    func testInitialization() throws {
        let lingoProvider = LingoProvider(application: self.application)
        lingoProvider.configuration = .init(defaultLocale: "en", localizationsDir: "Localizations")
        XCTAssertEqual(lingoProvider.configuration?.defaultLocale, "en")
    }
    
    static var allTests: [(String, (LingoVaporTests) -> () throws -> Void)] = [
        ("testInitialization", testInitialization),
    ]
    
}
