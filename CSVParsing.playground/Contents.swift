//: Playground - noun: a place where people can play

import Foundation
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
