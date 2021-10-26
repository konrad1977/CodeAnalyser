//
//  CodeAnalyser.swift
//  Projectexplorer
//
//  Created by Mikael Konradsson on 2021-03-07.
//

import Foundation
import Funswift

public struct SourceFile {
    public let path: String
    public let name: String
    public let data: String.SubSequence
    public let fileType: Filetype
}

public struct CodeAnalyser {
	public init () {}
}

// MARK: - Public synchrounous
extension CodeAnalyser {

    public func fileInfo(
        from startPath: String,
        language: Filetype = .all,
        filter: PathFilter = .empty
    ) -> IO<[Fileinfo]> {
        IO.pure(startPath)
            .flatMap(supportedFiletypes(language, filter: filter) >=> analyzeCodeFileInSubpaths)
    }

    public func fileLineInfo(
        from startPath: String,
        language: Filetype = .all,
        filter: PathFilter = .empty
    ) -> IO<[FileLineInfo]> {
        IO.pure(startPath)
            .flatMap(supportedFiletypes(language, filter: filter) >=> analyzeLineCountInSubpaths)
    }

    public func analyseLineCount(sourceFile: SourceFile) -> IO<FileLineInfo> {
        zip(
            IO.pure(sourceFile.path),
            IO.pure(sourceFile.name),
            SourceFileAnalysis.countLinesIn(sourceFile: sourceFile.data),
            IO.pure(sourceFile.fileType)
        ).map(FileLineInfo.init)
    }

    public func analyseSourcefile(sourceFile: SourceFile) -> IO<Fileinfo> {
        zip(
            IO.pure(sourceFile.path),
            IO.pure(sourceFile.name),
            SourceFileAnalysis.countClasses(filetype: sourceFile.fileType)(sourceFile.data),
            SourceFileAnalysis.countStructs(filetype: sourceFile.fileType)(sourceFile.data),
            SourceFileAnalysis.countEnums(filetype: sourceFile.fileType)(sourceFile.data),
            SourceFileAnalysis.countInterfaces(filetype: sourceFile.fileType)(sourceFile.data),
            SourceFileAnalysis.countFunctions(filetype: sourceFile.fileType)(sourceFile.data),
            SourceFileAnalysis.countImports(filetype: sourceFile.fileType)(sourceFile.data),
            SourceFileAnalysis.countExtensions(filetype: sourceFile.fileType)(sourceFile.data),
            SourceFileAnalysis.countLinesIn(sourceFile: sourceFile.data),
            IO.pure(sourceFile.fileType)
        )
        .map(Fileinfo.init)
    }

    public func statistics(
        from startPath: String,
        language: Filetype = .all
    ) -> IO<([LanguageSummary], [Statistics])> {
        fileInfo(
            from: startPath,
            language: language
        )
        .flatMap(createLanguageSummary)
    }
}

// MARK: - Async versions
extension CodeAnalyser {

    public func analyseLineCountAsync(sourceFile: SourceFile) -> Deferred<FileLineInfo> {
        Deferred(io:
            analyseLineCount(sourceFile: sourceFile)
        )
    }

    public func analyseSourcefileAsync(sourceFile: SourceFile) -> Deferred<Fileinfo> {
        Deferred(io:
            analyseSourcefile(sourceFile: sourceFile)
        )
    }

    public func statisticsAsync(
        from startPath: String,
        language: Filetype = .all
    ) -> Deferred<([LanguageSummary], [Statistics])> {
        Deferred(io:
            fileInfo(
                from: startPath,
                language: language
            )
            .flatMap(createLanguageSummary)
        )
    }

    public func fileInfoAsync(
        from startPath: String,
        language: Filetype = .all
    ) -> Deferred<[Fileinfo]> {
        Deferred(io:
            fileInfo(
                from: startPath,
                language: language
            )
        )
    }
}

// MARK: - Private
extension CodeAnalyser {
    private func supportedFiletypes(_ supportedFiletypes: Filetype, filter: PathFilter) -> (String) -> IO<[String]> {
        return { path in
            guard let paths = try? FileManager.default
                    .subpathsOfDirectory(atPath: path)
                    .filter(noneOf(filter.query).contains)
                    .filter(anyOf(supportedFiletypes.elements().map { $0.predicate }).contains)
            else { return IO { [] } }

            return IO { paths }
        }
    }

    private func fileData(from path: String) -> IO<String.SubSequence> {
        guard let file = try? String(contentsOfFile: path, encoding: .ascii)[...]
        else { return IO { "" } }

        return IO { file }
    }

    private func createFileInfo(_ path: String) -> IO<SourceFile> {
        fileData(from: path).map { data in
            let fileUrl = URL(fileURLWithPath: path)
            let filetype = Filetype(extension: fileUrl.pathExtension)
            let filename = fileUrl.lastPathComponent
            return SourceFile(path: fileUrl.relativePath, name: filename,  data: data, fileType: filetype)
        }
    }

    private func analyzeCodeFileInSubpaths(_ paths: [String]) -> IO<[Fileinfo]> {
        IO { paths
            .map(createFileInfo >=> analyseSourcefile(sourceFile:))
            .map { $0.unsafeRun() }
        }
    }

    private func analyzeLineCountInSubpaths(_ paths: [String]) -> IO<[FileLineInfo]> {
        IO { paths
                .map(createFileInfo >=> analyseLineCount(sourceFile:))
                .map { $0.unsafeRun() }
        }
    }

    private func createLanguageSummary(_ fileInfo: [Fileinfo]) -> IO<([LanguageSummary], [Statistics])> {

        let filteredListFor = filterered(fileInfo)

        let summary = zip(
            createSummaryForLanguage(.swift, fileInfo: filteredListFor(.swift).unsafeRun()),
            createSummaryForLanguage(.kotlin, fileInfo: filteredListFor(.kotlin).unsafeRun()),
            createSummaryForLanguage(.objectiveC, fileInfo: filteredListFor(.objectiveC).unsafeRun()),
            createSummaryForLanguage(.all, fileInfo: fileInfo)
        ).map { swift, kotlin, objc, all in
            [swift, kotlin, objc, all]
                .filter { $0.isEmpty() == false }
        }.unsafeRun()

        return IO { (summary, LanguageSummary.statistics(from: summary)) }
    }

    private func createSummaryForLanguage(_ filetype: Filetype, fileInfo: [Fileinfo]) -> IO<LanguageSummary> {

        guard fileInfo.count > 0
        else { return IO { .empty } }

        let (classes, structs, enums, interfaces, functions, lines, imports, extensions) =
        fileInfo.reduce(into: (0, 0, 0, 0, 0, 0, 0, 0)) { acc, fileInfo in
            acc.0 += fileInfo.classes
            acc.1 += fileInfo.structs
            acc.2 += fileInfo.enums
            acc.3 += fileInfo.interfaces
            acc.4 += fileInfo.functions
            acc.5 += fileInfo.linecount
            acc.6 += fileInfo.imports
            acc.7 += fileInfo.extensions
        }
        return IO {
            LanguageSummary(
                classes: classes,
                structs: structs,
                enums: enums,
                interfaces: interfaces,
                functions: functions,
                imports: imports,
                extensions: extensions,
                linecount: lines,
                filecount: fileInfo.count,
                filetype: filetype
            )
        }
    }

    private func filterered(_ info: [Fileinfo]) -> (Filetype) -> IO<[Fileinfo]> {
        return { filetype in IO { info.filter { $0.filetype == filetype } } }
    }
}

