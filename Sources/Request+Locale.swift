import Vapor
import Lingo

extension Request {
    var locale: String {
        if let session = try? session(), let sessionlocale = session["locale"] {
            return sessionlocale
        }
        // Parse locale, ordered from general case to special case
        // If nothing helps.. use "en"
        var locale: LocaleIdentifier = "en"

        // If Lingo has defaultLocale, use that
        if let lingo = try? make(Lingo.self) {
            locale = lingo.defaultLocale

            // If headers provide information, use those
            if var langHeader = http.headers.firstValue(name: .acceptLanguage) {
                langHeader = langHeader.components(separatedBy: .whitespaces).joined()
                let langValues = langHeader.components(separatedBy: ",").map { HeaderValue.parse($0) ?? HeaderValue($0, parameters: ["q":"0"]) }
                let availableLocales = (try? lingo.dataSource.availableLocales()) ?? [locale]
                var localeWeight = 0.0
                for lang in langValues {
                    let q = Double(lang.parameters["q"] ?? "1") ?? 1
                    if localeWeight < q {
                        if availableLocales.contains(lang.value) {
                            localeWeight = q
                            locale = lang.value
                        } else if let baseLang = lang.value.split(separator: "-").first, availableLocales.contains(String(baseLang)) {
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
