//
//  FileType.swift
//  pinfo
//
//  Created by Mikael Konradsson on 2021-03-09.
//

import Foundation

public struct Filetype: OptionSet {

	public let rawValue: Int

	public static let swift = Filetype(rawValue: 1 << 0)
	public static let kotlin = Filetype(rawValue: 1 << 1)
	public static let objectiveC = Filetype(rawValue: 1 << 2)

	public static let all: Filetype = [.swift, .kotlin, .objectiveC]
	public static let empty: Filetype = []

	public init (rawValue: Int) {
		self.rawValue = rawValue
	}
}

extension Filetype {

	public init(extension: String) {
		switch `extension` {
		case "kt", "kts", "ktm":
			self = .kotlin
		case "m", "h":
			self = .objectiveC
		case "swift":
			self = .swift
		default:
			self = .empty
		}
	}
}
