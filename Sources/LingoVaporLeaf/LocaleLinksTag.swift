import Vapor
import Leaf
import LingoVapor

public final class LocaleLinksTag: UnsafeUnescapedLeafTag {
    public init() {}
    public func render(_ tag: LeafContext) throws -> LeafData {
        guard let lingo = try tag.application?.lingoVapor.lingo()
        else {
            throw Abort(.internalServerError, reason: "Unable to get Lingo instance")
        }
        let locale = tag.request?.locale ?? lingo.defaultLocale
        
        guard tag.parameters.count == 2,
              let prefix = tag.parameters[0].string,
              let suffix = tag.parameters[1].string
        else {
            throw Abort(.internalServerError, reason: "Wrong parameters count")
        }
        
        let canonical = "<link rel=\"canonical\" href=\"\(prefix)\(locale)\(suffix)\" />\n"
        
        let alternates = try lingo.dataSource.availableLocales().map { alternate in
            "<link rel=\"alternate\" hreflang=\"\(alternate)\" href=\"\(prefix)\(alternate)\(suffix)\" />\n"
        }
        
        return LeafData.string(canonical + alternates.joined())
    }
}
