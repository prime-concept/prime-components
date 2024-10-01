@testable import PrimeUtilities

import XCTest

final class RandomAccessCollectionExtensionsTests: XCTestCase {
    
    func test_safe_indexWithinBounds() {
        let array = [1, 2, 3, 4, 5]
        
        let element = array[safe: 2]
        
        XCTAssertEqual(element, 3)
    }
    
    func test_safe_lowestValidIndex() {
        let array = [1, 2, 3]
        
        let element = array[safe: 0]
        
        XCTAssertEqual(element, 1)
    }
    
    func test_safe_highestValidIndex() {
        let array = [1, 2, 3]
        
        let element = array[safe: 2]
        
        XCTAssertEqual(element, 3)
    }
    
    func test_safe_indexTooLow() {
        let array = [1, 2, 3]
        
        let element = array[safe: -1]
        
        XCTAssertNil(element)
    }
    
    func test_safe_indexTooHigh() {
        let array = [1, 2, 3]
        
        let element = array[safe: 3]
        
        XCTAssertNil(element)
    }
    
    func test_safe_emptyCollection() {
        let array = [Int]()
        
        let element = array[safe: 0]
        
        XCTAssertNil(element)
    }
    
}
