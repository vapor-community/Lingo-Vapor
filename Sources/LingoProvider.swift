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
    let rootPath: String
    
    public init(defaultLocale: String, directory: String = "Localizations") {
        self.defaultLocale = defaultLocale
        self.rootPath = DirectoryConfig.detect().workDir + directory
    }
    
    public func register(_ services: inout Services) throws {
        services.register(Lingo.self) { (container) -> (Lingo) in
            return try Lingo(rootPath: self.rootPath, defaultLocale: self.defaultLocale)
        }
    }
    
    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return container.eventLoop.newSucceededFuture(result: ())
    }
    
}
