# CodeAnalyser

A description of this package.

##### Known bugs
- We analyse both .h / .m for Objective-c this will result in more functions than it actually is.

### How to use IO (Synchronous) and Deferred (Asynchronous)

#### Create and Start IO

```swift
CodeAnalyser()
	.start(startPath: "../somepath")
```

#### Lazy evaluation
CodeAnalyser that returns IO<Type> is completely lazy, its not until you run
```swift
.unsafeRun()
```
will the code be evaluated. 
	

#### Create and Start Deferred
Deferred will start the evaluation directly and return its result with a callback.

```swift
CodeAnalyser()
	.startAsync(startPath: "../somepath") { 
	(summary, statistics) in print("summary:\()\()") 
}
```


#### Gettings the result with statistics and summary

```swift
let (languageSummary: [LanguageSummary], statistics: [Statistics]) = CodeAnalyser()
  .start(startPath: "../somepath")
  .unsafeRun()
```


#### Gettings the result as a fileinfo list
Use this if you want to list all the files in a project and see statistics for each file
```swift
let fileInfos: [FileInfo] = CodeAnalyser()
  .start(startPath: "../somepath")
  .unsafeRun()
```

#### FileInfo model
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


#### Analysing a singlefile

```swift
func analyseSourcefile(_ filename: String, filedata: String, filetype: Filetype) ->IO<Fileinfo>
```
Usage:
```swift
let fileInfo = analyseSourcefile("AppDelegate.swift", filedata: filedata, filetype: .swift).unsafeRun()
```

#### Filetype Model
An enum to show wich language (or all/none)
```swift
public enum Filetype {
  case all
  case kotlin
  case swift
  case objectiveC
  case none
}
```

#### Language Summary Model
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

#### Statistics Model
Will return the percentage based on linecount.  Filetype will tell you which language it is.
```swift
public struct Statistics {
  public let filetype: Filetype
  public let lineCountPercentage: Double
}
```

#### Apps that uses CodeAnalyser
- ProjectExplorer (pinfo) https://github.com/konrad1977/ProjectExplorer