//
//  File.swift
//  
//
//  Created by Mikael Konradsson on 2021-03-20.
//

import Foundation
extension Filetype {
	public var predicate: Predicate<String> {
		switch self {
		case .all:
			return anyOf(
				Filetype.swift.predicate,
				Filetype.kotlin.predicate,
				Filetype.objectiveC.predicate
			)
		case .kotlin:
			return Predicate { $0.hasSuffix(".kt") || $0.hasSuffix(".ktm") || $0.hasSuffix(".kts") }
		case .swift:
			return Predicate { $0.hasSuffix(".swift") }
		case .objectiveC:
			return Predicate { $0.hasSuffix(".m") || $0.hasSuffix(".h") }
		case .empty:
			return Predicate { _ in false }
		default:
			return Predicate { _ in false }
		}
	}
}
