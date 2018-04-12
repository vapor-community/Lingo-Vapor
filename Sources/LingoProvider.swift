import Vapor
@_exported import Lingo

extension Lingo: Service {}

extension Container {
    public func lingo()throws -> Lingo {
        return try self.make(Lingo.self)
    }
}

public struct LingoProvider: Vapor.Provider {
    let root: String
    let defaultLocale: String
    
    public init(defaultLocale: String, directory: String = "Localizations") {
        let dir = DirectoryConfig.detect()
        
        self.root = dir.workDir + directory
        self.defaultLocale = defaultLocale
    }
    
    public func register(_ services: inout Services) throws {
        services.register(Lingo.self) { (container) -> (Lingo) in
            return try Lingo(rootPath: self.root, defaultLocale: self.defaultLocale)
        }
    }
    
    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> { return container.eventLoop.newSucceededFuture(result: ()) }
}
