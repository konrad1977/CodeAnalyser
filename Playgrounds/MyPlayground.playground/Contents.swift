import UIKit
import CodeAnalyser

let fileType: Filetype = [.kotlin, .swift]

anyOf(
	fileType
		.elements()
		.map({ $0.predicate })
).contains("file.m")

