import Foundation

public struct YouTubeVideoSnippet {
    
    public let id: String
    public let title: String
    public let channelTitle: String
    public let thumbnailURL: URL?
    public let isLive: Bool
    
    public init(id: String, title: String, channelTitle: String, thumbnailURL: URL?, isLive: Bool) {
        self.id = id
        self.title = title
        self.channelTitle = channelTitle
        self.thumbnailURL = thumbnailURL
        self.isLive = isLive
    }
    
}
