//
//  Filetype + anySequence.swift
//  
//
//  Created by Mikael Konradsson on 2021-03-20.
//

import Foundation

public extension Filetype {

	func elements() -> AnySequence<Self> {

		var remainingBits = rawValue
		var bitMask: RawValue = 1

		return AnySequence {
			return AnyIterator {
				while remainingBits != 0 {
					defer { bitMask = bitMask &* 2 }
					if remainingBits & bitMask != 0 {
						remainingBits = remainingBits & ~bitMask
						return Self(rawValue: bitMask)
					}
				}
				return nil
			}
		}
	}
}
