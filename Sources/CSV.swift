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

import Foundation

public struct Field {
	
	enum Error: Swift.Error {
		case fieldNotFound(String)
	}
	
	private let value: String?
	private let key: String
	
	init(value: String?, key: String) {
		self.value = value
		self.key = key
	}
	
	public func dematerialize() throws -> String {
		guard let value = value else {
			throw Field.Error.fieldNotFound(key)
		}
		return value
	}

}

extension Field.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .fieldNotFound(let path):
            return "Field not found at \(path)"
        }
    }
}

public struct Row {
	
	private let fields: [String]
	private let headers: [String]
	private let index: UInt
	
	fileprivate init(fields: [String], headers: [String], index: Int) {
		self.fields = fields
		self.headers = headers
		self.index = UInt(index)
	}
	
	public subscript(key: String) -> Field {
		let value = headers.index(of: key).map { self.fields[$0] }
		return Field(value: value, key: "[\(self.index)][\(key)]")
	}
	
	public subscript(index: Int) -> Field {
		if (0..<fields.count).contains(index) {
			return Field(value: fields[index], key: "[\(self.index)][\(index)]")
		}
		return Field(value: nil, key: "[\(self.index)][\(index)]")
	}
	
}

public struct CSV {
	
	enum Error: Swift.Error {
		case noHeader
		case typeMismatch
	}
	
	let headers: [String]
	let rows: [Row]
	
	public init(string: String, hasHeader: Bool = true) throws {
		let result = try csvParser.run(sourceName: "", input: string)
		headers = hasHeader ? result.first ?? [] : []
		rows = (hasHeader ? Array(result.dropFirst()) : result)
			.enumerated()
			.map { [headers] in Row(fields: $0.element, headers: headers, index: $0.offset) }
	}
	
	public func parse<T: CSVParsing>() throws -> [T] {
		return try rows.map { try T.parse(row: $0) }
	}
	
}
