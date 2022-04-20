import Vapor
import Leaf
import LingoVapor

public final class LocaleTag: LeafTag {
    public init() {}
    public func render(_ tag: LeafContext) throws -> LeafData {
        guard let lingo = try tag.application?.lingoVapor.lingo() else {
            throw Abort(.internalServerError, reason: "Unable to get Lingo instance")
        }
        return LeafData.string(tag.request?.locale ?? lingo.defaultLocale)
    }
}
