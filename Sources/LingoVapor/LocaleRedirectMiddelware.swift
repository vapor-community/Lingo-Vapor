import Vapor

public final class LocaleRedirectMiddelware: Middleware {
    public init() {}
    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        // Check if a language is passed in url
        guard let lang = request.parameters.get("locale")
        else {
            // Redirect corresponding to specified locale
            // For example, `/home/` will redirect to `/<request.locale>/home/`
            return request.eventLoop.makeSucceededFuture(
                request.redirect(to: "/\(request.locale)\(request.url.path)")
            )
        }
        
        // Get Lingo instance
        guard let lingo = try? request.application.lingoVapor.lingo(),
              let locales = try? lingo.dataSource.availableLocales()
        else {
            return request.eventLoop.makeFailedFuture(Abort(
                .internalServerError, reason: "Unable to get Lingo instance"
            ))
        }
        
        // Set request locale from url
        // For example, `/fr/home/` will display homepage in French
        request.session.data["locale"] = locales.contains(lang) ? lang : lingo.defaultLocale
        return next.respond(to: request)
    }
}
