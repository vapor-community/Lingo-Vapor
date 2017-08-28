import Vapor
import Lingo

extension Droplet {

    /// Convenience method for accessing Lingo object.
    ///
    /// Note that accessing this property might crash the app if the LingoProvider is not added.
    /// This tradeoff was done on purpose in order to gain a cleaner API (without optionals).
    public var lingo: Lingo {
        guard let lingo = self.storage["lingo"] as? Lingo else {
            fatalError("Lingo is not initialized. Make sure you have registered the provider by doing: `config.addProvider(LingoProvider.Provider.self)`.")
        }
        
        return lingo
    }

}

public struct Provider: Vapor.Provider {
    
    public let lingo: Lingo
    public static let repositoryName = "lingo-provider"
    
    public init(config: Config) throws {
        guard let lingo = config["lingo"] else {
            throw ConfigError.missingFile("lingo")
        }
        
        // Check if `localizationsDir` is specified in the config,
        // otherwise default to workDir/Localizations
        let rootPath: String
        if let localizationsDir = lingo["localizationsDir"]?.string {
            rootPath = config.workDir.appending(localizationsDir)
        } else {
            rootPath = config.workDir.appending("Localizations")
        }
        
        /// Extract the default locale
        guard let defaultLocale = lingo["defaultLocale"]?.string else {
            throw ConfigError.missing(key: ["defaultLocale"], file: "lingo", desiredType: String.self)
        }
        
        self.lingo = try Lingo(rootPath: rootPath, defaultLocale: defaultLocale)
    }

    public func boot(_ droplet: Droplet) throws {
        droplet.storage["lingo"] = self.lingo
    }

    public func boot(_ config: Config) throws { }
    public func beforeRun(_ droplet: Droplet) throws { }
    
}
