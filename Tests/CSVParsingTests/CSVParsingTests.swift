//  Copyright (c) 2017, Benoît Layer
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  * Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  * The name of the author may not be used to endorse or promote
//  products derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL BENOIT LAYER BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import XCTest
@testable import CSVParsing

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

class CSVParsingTests: XCTestCase {
	
	var csv: CSV {
		let path = Bundle(for: type(of: self)).path(forResource: "demo", ofType: "csv")
        return try! CSV(string: String(contentsOfFile: path!))
	}
	
	var persons: [Person] {
		do {
			return try csv.parse()
		} catch {
			XCTFail("Parsing Failed")
			return []
		}
	}
	
    func testEntriesCount() {
        XCTAssertEqual(persons.count, 5)
    }
	
	func testLastEntryAge() {
		XCTAssertEqual(persons.last?.age, .some(18))
	}
	
	func testSubscript() {
		guard let header = csv.headers.first else {
			XCTFail("No header found")
			return
		}
		XCTAssertEqual((try? csv.rows[0][0].dematerialize()), try? csv.rows[0][header].dematerialize())
	}
	
}
