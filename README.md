# CSVParsing
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](#carthage) [![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-orange.svg)](#swift-package-manager) ![Swift 3.0.x](https://img.shields.io/badge/Swift-3.0.x-orange.svg) ![platforms](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20Linux-lightgrey.svg)

Simple __CSV parsing library__ relying on [SwiftParsec](https://github.com/davedufresne/SwiftParsec) (parser combinator library)

## Usage
Make your model conform to `CSVParsing`. Use the `Row` parameter to subscript with an index (`Int`) or a key (`String`) to get any given `Field`.

```swift
import CSVParsing

struct Person {
	let lastName: String
	let firstName: String
	let phone: String
	let age: Int
}

extension Person: CSVParsing {

	static func parse(row: Row) throws -> Person {
		return try Person(
			lastName: row["Last Name"].dematerialize(),
			firstName: row["First Name"].dematerialize(),
			phone: row["Phone"].dematerialize(),
			age: Int(row["Age"].dematerialize())!)
	}

}

let path = Bundle.main.path(forResource: "demo", ofType: "csv")

// For demo puprose, there's no error handling
let csvContent = try! String(contentsOfFile: path!)
let csv = try! CSV(string: csvContent)
let persons: [Person] = try! csv.parse()

```

The above sample code comes from the embedded playground file.

## License

Released under the New BSD License. See LICENSE for details.
