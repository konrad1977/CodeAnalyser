# CodeAnalyser

A description of this package.

##### Known bugs
- We analyse both .h / .m for Objective-c this will result in more functions than it actually is.

### How to use
Its possible to analyse the code both synchronous ```IO<A>``` or asynchronous ```Deferred<A>```.
Internally both use ```IO<A>``` which is blocking the thread until its done, but it can be started wrapped in a Deferred for a better experience with apps with GUI.

```IO<A>``` Is totally lazy, it wont execute anything until you call ```unsafeRun()``` on the other hand ```Deferred``` will start the analyses immediately but wont block the thread, but instead deliver its result by callback when its done. 

All version that returns a ```Deferred``` has a **Async**(...) postfix in the function signature. Ex:

##### Deferred
```swift
.startAsync(startPath: "../somepath") -> Deferred<[FileInfo]>
.startAsync(startPath: "../somepath") -> Deferred<([LanguageSummary], [Statistics])>
```

##### IO
```swift
.start(startPath: "../somepath") -> IO<[FileInfo]>
.start(startPath: "../somepath") -> IO<([LanguageSummary], [Statistics])>
```


#### There are three ways of running analysis.
- *Path* will run recusively. There is two overloads with different results:
	- Statistics and summary for all files ```([LanguageSummary], [Statistics])```
	- A list of fileinfo for all files ```[FileInfo]```
- Analyse a single file ```FileInfo```


#### Create

```swift
CodeAnalyser()
	.start(startPath: "../somepath")
```

#### Create and Start Deferred
Deferred will start the evaluation directly and return its result with a callback.

```swift
CodeAnalyser()
	.startAsync(startPath: "../somepath") { (summary, statistics) in
		print("summary:\(summary)\(statistics)") 
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
Synchronous:

```swift
func analyseSourcefile(_ filename: String, filedata: String, filetype: Filetype) ->IO<Fileinfo>
```
Asynchronous:

```swift
func analyseSourcefileAsync(_ filename: String, filedata: String, filetype: Filetype) ->Deferred<Fileinfo>
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
- pinfo (CLI) https://github.com/konrad1977/ProjectExplorer
