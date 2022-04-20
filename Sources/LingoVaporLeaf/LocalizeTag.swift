import Vapor
import Leaf
import LingoVapor

public final class LocalizeTag: LeafTag {
    public init() {}
    public func render(_ tag: LeafContext) throws -> LeafData {
        guard let lingo = try tag.application?.lingoVapor.lingo() else {
            throw Abort(.internalServerError, reason: "Unable to get Lingo instance")
        }
        let locale = tag.request?.locale ?? lingo.defaultLocale
        
        guard let key = tag.parameters.first?.string else {
            throw Abort(.internalServerError, reason: "First parameter for localize tag is no string")
        }
        
        if tag.parameters.count == 2 {
            guard let body = tag.parameters[1].string,
                  let bodyData = body.data(using: .utf8),
                  let interpolations = try? JSONSerialization.jsonObject(with: bodyData, options: []) as? [String: AnyObject]
            else {
                throw Abort(.internalServerError, reason: "Body of localize tag invalid")
            }
            return .string(lingo.localize(key, locale: locale, interpolations: interpolations))
        } else {
            return .string(lingo.localize(key, locale: locale))
        }
    }
}
