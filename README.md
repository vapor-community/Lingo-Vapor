# Lingo Provider

[![Language](https://img.shields.io/badge/Swift-4-brightgreen.svg)](http://swift.org)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/vapor-community/markdown-provider/master/LICENSE)

A Vapor provider for [Lingo](https://github.com/miroslavkovac/Lingo) - a pure Swift localization library ready to be used in Server Side Swift projects.

## Setup 

### Add a dependancy

Add LingoProvider as a dependancy in your `Package.swift` file:

```swift
dependencies: [
	...,
	.package(url: "https://github.com/vapor-community/lingo-vapor.git", from: "3.0.0")]
]
```

### Add the Provider

In the `configure.swift` simply initialize the `LingoVapor` with a default locale:

```swift
import LingoVapor
...
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
	...
	let lingoProvider = LingoProvider(defaultLocale: "en", localizationsDir: "Localizations")
	try services.register(lingoProvider)
}
```

> The `localizationsDir` can be omitted, as the _Localizations_ is also the default path. Note that this folder should exist under the _workDir_.

## Use

After you have registered the provider, you can use any `Container` to create `Lingo`:

```swift
let lingo = try someContainer.make(Lingo.self)
...
let localizedTitle = lingo.localize("welcome.title", locale: "en")
```

Use the following syntax for defining localizations in a JSON file:

```swift
{
	"title": "Hello Swift!",
	"greeting.message": "Hi %{full-name}!",
	"unread.messages": {
		"one": "You have one unread message.",
		"other": "You have %{count} unread messages."
	}
}
```

### Inside Leaf templates

When using [Leaf](https://github.com/vapor/leaf) as templating engine, you can add a custom tag for localization inside the templates.

```swift
public final class LocalizeTag: TagRenderer {
    public init() {}

    public func render(tag: TagContext) throws -> EventLoopFuture<TemplateData> {
        try tag.requireParameterCount(1)
        let lingo = try tag.container.make(Lingo.self)

        let locale = (tag.container as? Request)?.locale ?? lingo.defaultLocale
        
        guard let key = tag.parameters[0].string else {
            throw Abort(.internalServerError, reason: "First parameter for localize tag is no string")
        }
        
        if let body = tag.body {
            return tag.serializer.serialize(ast: body).map(to: TemplateData.self) { body in
                guard let rawBodyData = String(data: body.data, encoding: .utf8),
                    let bodyData = "{\(rawBodyData)}".data(using: .utf8),
                    let interpolations = try? JSONSerialization.jsonObject(with: bodyData, options: []) as? [String: AnyObject] else {
                    throw Abort(.internalServerError, reason: "Body of localize tag invalid")
                }
                return .string(lingo.localize(key, locale: locale, interpolations: interpolations))
            }
        } else {
            return Future.map(on: tag) {
                .string(lingo.localize(key, locale: locale))
            }
        }
    }
}
```

After adding this to your app, you have to load this custom tag. Afterwards you can call it inside the Leaf templates. It even supports keys with variables. Just fill the variables inside the body.

```
#localize("thisisthelingokey")
#localize("lingokeywithvariable") {"foo":"bar"}
```

## Learn more

- [Lingo](https://github.com/miroslavkovac/Lingo) - learn more about the localization file format, pluralization support, and see how you can get the most out of the Lingo.
