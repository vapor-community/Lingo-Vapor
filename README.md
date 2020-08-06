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
	.package(url: "https://github.com/vapor-community/lingo-vapor.git", from: "4.0.0")]
]
```

### Add the Provider

In the `configure.swift` simply initialize the `LingoVapor` with a default locale:

```swift
import LingoVapor
...
public func configure(_ app: Application) throws {
	...
	app.lingoVapor.configuration = .init(defaultLocale: "en", localizationsDir: "Localizations")
}
```

> The `localizationsDir` can be omitted, as the _Localizations_ is also the default path. Note that this folder should exist under the _workDir_.

## Use

After you have configured the provider, you can use  `lingoVapor` service to create `Lingo`:

```swift
let lingo = try app.lingoVapor.lingo()
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

## Learn more

- [Lingo](https://github.com/miroslavkovac/Lingo) - learn more about the localization file format, pluralization support, and see how you can get the most out of the Lingo.
