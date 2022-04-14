import Vapor
import Lingo

extension Request {
    public var locale: String {
        if let sessionlocale = session.data["locale"] {
            return sessionlocale
        }
        // Parse locale, ordered from general case to special case
        // If nothing helps.. use "en"
        var locale: LocaleIdentifier = "en"

        // If Lingo has defaultLocale, use that
        if let lingo = try? application.lingoVapor.lingo() {
            locale = lingo.defaultLocale

            // If headers provide information, use those
            if var langHeader = headers.first(name: .acceptLanguage) {
                langHeader = langHeader.components(separatedBy: .whitespaces).joined()
                let langValues = langHeader.components(separatedBy: ",").map { h -> (String, String) in
                    // Core is no longer available with Vapor 4, so we have no way to use `HeaderValue` anymore
                    //HeaderValue.parse($0) ?? HeaderValue($0, parameters: ["q":"0"])
                    let parts = h.split(separator: ";", maxSplits: 1).map(String.init)
                    return (parts[0], "1")
                }
                let availableLocales = (try? lingo.dataSource.availableLocales()) ?? [locale]
                var localeWeight = 0.0
                for lang in langValues {
                    let q = Double(lang.1) ?? 1
                    if localeWeight < q {
                        if availableLocales.contains(lang.0) {
                            localeWeight = q
                            locale = lang.0
                        } else if let baseLang = lang.0.split(separator: "-").first, availableLocales.contains(String(baseLang)) {
                            localeWeight = q-0.01
                            locale = String(baseLang)
                        }
                    }
                }
            }
        }

        return locale
    }
}
