import Foundation
import PrimeInterfaces

// MARK: - Decodable

extension YouTubeVideoSnippet: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id, snippet
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(String.self, forKey: .id)
        let snippet = try container.decode(_YouTubeVideoSnippet.self, forKey: .snippet)
        
        self.init(
            id: id,
            title: snippet.title,
            channelTitle: snippet.channelTitle,
            thumbnailURL: snippet.thumbnails?.bestQuality,
            isLive: snippet.liveBroadcastContent == "live" || snippet.liveBroadcastContent == "upcoming"
        )
    }
    
}

// MARK: - Internals

fileprivate struct _YouTubeVideoSnippet: Decodable {
    let title: String
    let channelTitle: String
    let thumbnails: Thumbnails?
    let liveBroadcastContent: String?
}

extension _YouTubeVideoSnippet {
    
    fileprivate struct Thumbnails: Decodable {
        
        let bestQuality: URL?
        
        enum CodingKeys: String, CodingKey {
            case `default`, medium, high
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let `default` = try? container.decode(Thumbnail.self, forKey: .default)
            let medium = try? container.decode(Thumbnail.self, forKey: .medium)
            let high = try? container.decode(Thumbnail.self, forKey: .high)
            
            bestQuality = (high ?? medium ?? `default`)?.url
        }
        
    }
    
}

extension _YouTubeVideoSnippet.Thumbnails {
    
    fileprivate struct Thumbnail: Decodable {
        let url: URL
    }
    
}
