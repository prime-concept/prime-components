@testable import PrimeServices

import TestUtilities
import XCTest

// MARK: - Tests

final class YouTubeServiceTests: XCTestCase {
    
    private var service: YouTubeService!
    
    private var networkingService: SimpleNetworkingServiceMock!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        networkingService = SimpleNetworkingServiceMock()
        service = YouTubeService(networkingService: networkingService, youTubeAPIKey: "TEST_API_Key")
    }
    
    func test_snippetsForVideoIDs_noVideoIDs() async {
        do {
            _ = try await service.snippets(forVideoIDs: [])
            XCTFail("Expected an error")
        } catch YouTubeService.Error.noVideoIDs {
            XCTAssertEqual(networkingService.executeRequest_invocationCount, 0)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_snippetsForVideoIDs_networkingFailure() async {
        networkingService.executeRequest_result = .failure(NSError(domain: "TEST_Error_Domain", code: 123))
        
        do {
            _ = try await service.snippets(forVideoIDs: ["dQw4w9WgXcQ", "PGNiXGX2nLU"])
            XCTFail("Expected an error")
        } catch YouTubeService.Error.networkingFailure(let error as NSError) {
            XCTAssertEqual(error.domain, "TEST_Error_Domain")
            XCTAssertEqual(error.code, 123)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_snippetsForVideoIDs_decodingFailure() async {
        networkingService.executeRequest_result = .success((decodingFailureResponseData, .init()))
        
        do {
            _ = try await service.snippets(forVideoIDs: ["dQw4w9WgXcQ", "PGNiXGX2nLU"])
            XCTFail("Expected an error")
        } catch YouTubeService.Error.decodingFailure(let error) {
            guard case .keyNotFound(let key, _) = error as? DecodingError else {
                return XCTFail("Unexpected error: \(error.localizedDescription)")
            }
            
            XCTAssertEqual(key.stringValue, "title")
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_snippetsForVideoIDs_success() async throws {
        networkingService.executeRequest_result = .success((validResponseData, .init()))
        
        let snippets = try await service.snippets(forVideoIDs: ["dQw4w9WgXcQ", "PGNiXGX2nLU"])
        
        XCTAssertEqual(networkingService.executeRequest_invocationCount, 1)
        XCTAssertEqual(
            networkingService.executeRequest_requests[0].url?.absoluteString,
            "https://www.googleapis.com/youtube/v3/videos?key=TEST_API_Key&part=snippet&id=dQw4w9WgXcQ,PGNiXGX2nLU"
        )
        XCTAssertEqual(snippets.count, 2)
        XCTAssertEqual(snippets[0].id, "dQw4w9WgXcQ")
        XCTAssertEqual(snippets[0].title, "Rick Astley - Never Gonna Give You Up (Official Music Video)")
        XCTAssertEqual(snippets[0].channelTitle, "Rick Astley")
        XCTAssertEqual(snippets[0].thumbnailURL?.absoluteString, "https://i.ytimg.com/vi/dQw4w9WgXcQ/hqdefault.jpg")
        XCTAssertTrue(snippets[0].isLive)
        XCTAssertEqual(snippets[1].id, "PGNiXGX2nLU")
        XCTAssertEqual(snippets[1].title, "Dead Or Alive - You Spin Me Round (Like a Record) (Official Video)")
        XCTAssertEqual(snippets[1].channelTitle, "DeadOrAliveVEVO")
        XCTAssertEqual(snippets[1].thumbnailURL?.absoluteString, "https://i.ytimg.com/vi/PGNiXGX2nLU/hqdefault.jpg")
        XCTAssertFalse(snippets[1].isLive)
    }
    
    func test_urlRequestForVideoIDs_noVideoIDs() async {
        let request = await service.urlRequest(forVideoIDs: [])
        
        XCTAssertEqual(request?.httpMethod, "GET")
        XCTAssertEqual(
            request?.url?.absoluteString,
            "https://www.googleapis.com/youtube/v3/videos?key=TEST_API_Key&part=snippet&id="
        )
    }
    
    func test_urlRequestForVideoIDs_singleVideoID() async {
        let request = await service.urlRequest(forVideoIDs: ["dQw4w9WgXcQ"])
        
        XCTAssertEqual(request?.httpMethod, "GET")
        XCTAssertEqual(
            request?.url?.absoluteString,
            "https://www.googleapis.com/youtube/v3/videos?key=TEST_API_Key&part=snippet&id=dQw4w9WgXcQ"
        )
    }
    
    func test_urlRequestForVideoIDs_multipleVideoIDs() async {
        let request = await service.urlRequest(forVideoIDs: ["dQw4w9WgXcQ", "PGNiXGX2nLU"])
        
        XCTAssertEqual(request?.httpMethod, "GET")
        XCTAssertEqual(
            request?.url?.absoluteString,
            "https://www.googleapis.com/youtube/v3/videos?key=TEST_API_Key&part=snippet&id=dQw4w9WgXcQ,PGNiXGX2nLU"
        )
    }
    
}

// MARK: - Utilities

extension YouTubeServiceTests {
    
    private var validResponseData: Data {
        """
        {
          "items": [
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
            },
            {
              "id": "PGNiXGX2nLU",
              "snippet": {
                "title": "Dead Or Alive - You Spin Me Round (Like a Record) (Official Video)",
                "thumbnails": {
                  "default": {
                    "url": "https://i.ytimg.com/vi/PGNiXGX2nLU/default.jpg",
                    "width": 120,
                    "height": 90
                  },
                  "medium": {
                    "url": "https://i.ytimg.com/vi/PGNiXGX2nLU/mqdefault.jpg",
                    "width": 320,
                    "height": 180
                  },
                  "high": {
                    "url": "https://i.ytimg.com/vi/PGNiXGX2nLU/hqdefault.jpg",
                    "width": 480,
                    "height": 360
                  },
                  "standard": {
                    "url": "https://i.ytimg.com/vi/PGNiXGX2nLU/sddefault.jpg",
                    "width": 640,
                    "height": 480
                  },
                  "maxres": {
                    "url": "https://i.ytimg.com/vi/PGNiXGX2nLU/maxresdefault.jpg",
                    "width": 1280,
                    "height": 720
                  }
                },
                "channelTitle": "DeadOrAliveVEVO",
                "liveBroadcastContent": "none"
              }
            }
          ],
          "pageInfo": {
            "totalResults": 2,
            "resultsPerPage": 2
          }
        }
        """.data(using: .utf8)!
    }
    
    private var decodingFailureResponseData: Data {
        // The response reads `tile` instead of `title`.
        """
        {
          "items": [
            {
              "id": "dQw4w9WgXcQ",
              "snippet": {
                "tile": "Rick Astley - Never Gonna Give You Up (Official Music Video)",
                "channelTitle": "Rick Astley",
                "liveBroadcastContent": "live"
              }
            }
          ]
        }
        """.data(using: .utf8)!
    }
    
}
