import UIKit
import CodeAnalyser
import Funswift
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true


//let fileType: Filetype = [.kotlin, .swift]
//
//anyOf(
//	fileType
//		.elements()
//		.map({ $0.predicate })
//).contains("file.m")


let path = "/Users/mikaelkonradsson/Library/Developer/Xcode/DerivedData/Projectexplorer-cakkqemthjvphwcsibwdpzneciad/Build/Products/Debug/"

CodeAnalyser()
    .fileLineInfo(from: path, language: .swift, filter: .pods)
    .unsafeRun()
