import Foundation

public struct Comment {
    let line: Int
    let comment: String
}

public struct Todo {
    public let path: String
    public let filename: String
    public let comments: [Comment]
    public let filetype: Filetype
}
