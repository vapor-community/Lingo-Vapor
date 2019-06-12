import Vapor
import Lingo

extension Lingo: Service {}

extension Container {
    
    public func lingo() throws -> Lingo {
        return try self.make(Lingo.self)
    }
    
}

public struct LingoProvider: Vapor.Provider {
    
    let defaultLocale: String
    let localizationsDir: String
    
    public init(defaultLocale: String, localizationsDir: String = "Localizations") {
        self.defaultLocale = defaultLocale
        self.localizationsDir = localizationsDir
    }
    
    public func register(_ services: inout Services) throws {
        services.register(Lingo.self) { (container) -> (Lingo) in
            let dirConfig = try container.make(DirectoryConfig.self)
            let rootPath = dirConfig.workDir + self.localizationsDir
            return try Lingo(rootPath: rootPath, defaultLocale: self.defaultLocale)
        }
    }
    
    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return container.eventLoop.newSucceededFuture(result: ())
    }
    
}
