# CodeAnalyser

A description of this package.

##### Known bugs
- We analyse both .h / .m for Objective-c this will result in more functions than it actually is.

### How to use
Its possible to analyse the code both synchronous ```IO<A>``` or asynchronous ```Deferred<A>```.
Internally both use ```IO<A>``` which is blocking the thread until its done, but it can be started wrapped in a Deferred for a better experience with apps with GUI.

```IO<A>``` Is totally lazy, it wont execute anything until you call ```unsafeRun()``` and ```Deferred``` will start the analyses when you run it and the result will come as a callback. 

All version that returns a ```Deferred``` has a **Async**(...) postfix in the function signature. Ex:

##### Deferred
```swift
CodeAnalyser().fileInfoAsync(from: "../somepath", language: [.swift, .kotlin]) -> Deferred<[FileInfo]>
CodeAnalyser().statisticsAsync(from: "../somepath", language: [.swift, .objectiveC]) -> Deferred<([LanguageSummary], [Statistics])>
```

Getting value out of deferred:
```swift
CodeAnalyser()
  .fileInfoAsync(from: "../somepath", language: [.swift, .kotlin])
  .run { fileinfo in 
    print(fileinfo)
  }
```

##### IO
```swift
CodeAnalyser().fileInfo(from: "../somepath") -> IO<[FileInfo]>
CodeAnalyser().statistics(from: "../somepath", language: .swift) -> IO<([LanguageSummary], [Statistics])>
```

##### Getting value out of IO
```swift
let fileinfo = CodeAnalyser()
  .fileInfo(from: "../somepath", language: [.swift, .kotlin])
  .unsafeRun()
```

#### There are three ways of running analysis.
- *Path* will run recusively. There is two overloads with different results:
	- Statistics and summary for all files ```([LanguageSummary], [Statistics])```
	- A list of fileinfo for all files ```[FileInfo]```
- Analyse a single file ```FileInfo```


#### Gettings the result with statistics and summary
Default language parameter is all, you can specify one or multiple languages you want to analyse. Whats happening under the hood is that all files with matching extension will be analysed. 

```swift
let (languageSummary: [LanguageSummary], statistics: [Statistics]) = CodeAnalyser()
  .statistics(from: "../somepath", language: .swift)
  .unsafeRun()
```


#### Gettings the result as a fileinfo list
Use this if you want to list all the files in a project and see statistics for each file

```swift
let fileInfos: [FileInfo] = CodeAnalyser()
  .fileInfo(from: "../somepath")
  .unsafeRun()
```

#### Analysing a singlefile
Synchronous:

```swift
func analyseSourcefile(_ filename: String, filedata: String, filetype: Filetype) ->IO<Fileinfo>
```
Asynchronous:

```swift
func analyseSourcefileAsync(_ filename: String, filedata: String, filetype: Filetype) ->Deferred<Fileinfo>
```

### Models

#### FileInfo
```swift
public struct Fileinfo {
  public let filename: String
  public let classes: Int
  public let structs: Int
  public let enums: Int
  public let interfaces: Int
  public let functions: Int
  public let imports: Int 
  public let extensions: Int
  public let linecount: Int
  public let filetype: Filetype
}
```

#### Filetype
An enum to show wich language (or all/none)

```swift
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
```

#### Language Summary
Language Summary holds the information about every language. 
Filetype will tell you which language it is.

```swift
public struct LanguageSummary {
  public let classes: Int
  public let structs: Int
  public let enums: Int
  public let interfaces: Int
  public let functions: Int
  public let imports: Int
  public let extensions: Int
  public let linecount: Int
  public let filecount: Int
  public let filetype: Filetype
}
```

#### Statistics
Will return the percentage based on linecount.  Filetype will tell you which language it is.

```swift
public struct Statistics {
  public let filetype: Filetype
  public let lineCountPercentage: Double
}
```

#### Apps that uses CodeAnalyser
- pinfo (CLI) https://github.com/konrad1977/ProjectExplorer
