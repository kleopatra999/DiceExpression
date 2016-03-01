// Copyright (c) 2016  Marco Conti
//
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
//
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
//
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import XCTest
@testable import DiceExpression

class CollectionsTests: XCTestCase {

    func testThatAnArrayIsGrouped() {
        
        // given
        let sut = [1,2,3,4,5,6]
        
        // when
        let result = try! sut.groupedArray(3)
        
        // then
        XCTAssertEqual(result, [[1,2,3],[4,5,6]])
    }
    
    func testThatAnArraySliceIsGrouped() {
        
        // given
        let sut = ArraySlice<String>(count: 6, repeatedValue: "a")
        
        // when
        let result = try! sut.groupedArray(2)
        
        // then
        XCTAssertEqual(result, [["a","a"],["a","a"],["a","a"]])
    }
    
    func testThatItThrowsIfTheContainerSizeIsNotAMultipleOfTheGroupSize() {
        
        // given
        let sut = [1,2,3]
        
        // when
        do {
            try sut.groupedArray(2)
            XCTFail("Did not throw")
        }
        catch CollectionClusteringError.SizeIsNotMultipleOfClusterSize {
            // pass
        }
        catch {
            XCTFail("Threw unexpected error: \(error)")
        }
    }
    
    func testThatItReturnsEmptyArrayIfTheCollectionIsEmpty() {
        // given
        let sut : [Int] = []
        
        // when
        let result = try! sut.groupedArray(3)
        
        // then
        XCTAssertEqual(result, [])
    }
}