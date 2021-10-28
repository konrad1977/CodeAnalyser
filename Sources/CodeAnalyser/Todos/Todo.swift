import Foundation

public struct Comment {
    public let line: Int
    public let comment: String
}

public struct Todo {
    public let path: String
    public let filename: String
    public let comments: [Comment]
    public let filetype: Filetype
}
