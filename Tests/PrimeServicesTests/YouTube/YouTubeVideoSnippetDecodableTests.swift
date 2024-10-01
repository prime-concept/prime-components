@testable import PrimeServices

import PrimeInterfaces
import XCTest

final class YouTubeVideoSnippetDecodableTests: XCTestCase {
    
    private var decoder: JSONDecoder!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        decoder = JSONDecoder()
    }
    
    func test_initFromDecoder_success() throws {
        let responseString = """
        {
          "id": "dQw4w9WgXcQ",
          "snippet": {
            "title": "Rick Astley - Never Gonna Give You Up (Official Music Video)",
            "thumbnails": {
              "default": {
                "url": "https://i.ytimg.com/vi/dQw4w9WgXcQ/default.jpg",
                "width": 120,
                "height": 90
              },
              "medium": {
                "url": "https://i.ytimg.com/vi/dQw4w9WgXcQ/mqdefault.jpg",
                "width": 320,
                "height": 180
              },
              "high": {
                "url": "https://i.ytimg.com/vi/dQw4w9WgXcQ/hqdefault.jpg",
                "width": 480,
                "height": 360
              },
              "standard": {
                "url": "https://i.ytimg.com/vi/dQw4w9WgXcQ/sddefault.jpg",
                "width": 640,
                "height": 480
              },
              "maxres": {
                "url": "https://i.ytimg.com/vi/dQw4w9WgXcQ/maxresdefault.jpg",
                "width": 1280,
                "height": 720
              }
            },
            "channelTitle": "Rick Astley",
            "liveBroadcastContent": "live"
          }
        }
        """
        let responseData = responseString.data(using: .utf8)!
        
        let snippet = try decoder.decode(YouTubeVideoSnippet.self, from: responseData)
        
        XCTAssertEqual(snippet.id, "dQw4w9WgXcQ")
        XCTAssertEqual(snippet.title, "Rick Astley - Never Gonna Give You Up (Official Music Video)")
        XCTAssertEqual(snippet.channelTitle, "Rick Astley")
        XCTAssertEqual(snippet.thumbnailURL?.absoluteString, "https://i.ytimg.com/vi/dQw4w9WgXcQ/hqdefault.jpg")
        XCTAssertEqual(snippet.isLive, true)
    }
    
    func test_initFromDecoder_missingRequiredFields() {
        // `id` and `title` are missing
        let responseString = """
        {
          "snippet": {
            "thumbnails": {
              "default": {
                "url": "https://i.ytimg.com/vi/dQw4w9WgXcQ/default.jpg",
                "width": 120,
                "height": 90
              },
              "medium": {
                "url": "https://i.ytimg.com/vi/dQw4w9WgXcQ/mqdefault.jpg",
                "width": 320,
                "height": 180
              },
              "standard": {
                "url": "https://i.ytimg.com/vi/dQw4w9WgXcQ/sddefault.jpg",
                "width": 640,
                "height": 480
              }
            },
            "channelTitle": "Rick Astley"
          }
        }
        """
        let responseData = responseString.data(using: .utf8)!
        
        XCTAssertThrowsError(try decoder.decode(YouTubeVideoSnippet.self, from: responseData)) { error in
            guard case .keyNotFound(let key, _) = error as? DecodingError else {
                return XCTFail("Unexpected error: \(error.localizedDescription)")
            }
            
            XCTAssertEqual(key.stringValue, "id")
        }
    }
    
    func test_initFromDecoder_missingOptionalFields() throws {
        let responseString = """
        {
          "id": "dQw4w9WgXcQ",
          "snippet": {
            "title": "Rick Astley - Never Gonna Give You Up (Official Music Video)",
            "channelTitle": "Rick Astley"
          }
        }
        """
        let responseData = responseString.data(using: .utf8)!
        
        let snippet = try decoder.decode(YouTubeVideoSnippet.self, from: responseData)
        
        XCTAssertEqual(snippet.id, "dQw4w9WgXcQ")
        XCTAssertEqual(snippet.title, "Rick Astley - Never Gonna Give You Up (Official Music Video)")
        XCTAssertEqual(snippet.channelTitle, "Rick Astley")
        XCTAssertNil(snippet.thumbnailURL)
        XCTAssertEqual(snippet.isLive, false)
    }
    
    func test_initFromDecoder_invalidOptionalFields() throws {
        let responseString = """
        {
          "id": "dQw4w9WgXcQ",
          "snippet": {
            "title": "Rick Astley - Never Gonna Give You Up (Official Music Video)",
            "thumbnails": {
              "default": {
                "url": "https://i.ytimg.com/vi/dQw4w9WgXcQ/default.jpg"
              },
              "medium": {
                "url": "https://<!INVALID URL!>/vi/dQw4w9WgXcQ/mqdefault.jpg",
                "width": 320,
                "height": 180
              },
              "high": { }
            },
            "channelTitle": "Rick Astley",
            "liveBroadcastContent": "unknown_value"
          }
        }
        """
        let responseData = responseString.data(using: .utf8)!
        
        let snippet = try decoder.decode(YouTubeVideoSnippet.self, from: responseData)
        
        XCTAssertEqual(snippet.id, "dQw4w9WgXcQ")
        XCTAssertEqual(snippet.title, "Rick Astley - Never Gonna Give You Up (Official Music Video)")
        XCTAssertEqual(snippet.channelTitle, "Rick Astley")
        XCTAssertEqual(snippet.thumbnailURL?.absoluteString, "https://i.ytimg.com/vi/dQw4w9WgXcQ/default.jpg")
        XCTAssertEqual(snippet.isLive, false)
    }
    
}
