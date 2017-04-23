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
import DiceExpression

class RandomTests: XCTestCase {
}

// MARK: - Random integer
extension RandomTests {
    
    func testThatItReturnsTheNumberWhenTheRangeIsOnlyOneNumber() {
        
        (0...100).forEach { _ in
            // when
            let i = randomInteger(1, to: 1)
            
            // then
            XCTAssertEqual(i, 1)
        }
    }
    
    func testThatItReturnsTheNumberWhenTheRangeIsOnlyZero() {
        
        (0...100).forEach { _ in
            // when
            let i = randomInteger(0, to: 0)
            
            // then
            XCTAssertEqual(i, 0)
        }
    }
    
    func testThatItReturnsTheNumberWhenTheRangeIsOnlyOneNegativeNumber() {
        
        (0...100).forEach { _ in
            // when
            let i = randomInteger(-2, to: -2)
            
            // then
            XCTAssertEqual(i, -2)
        }
    }
    
    func testThatItReturnsAValidNumberWhenTheFirstArgumentIsGreater() {
        
        (0...100).forEach { _ in
            // when
            let i = randomInteger(2, to: 1)
            
            // then
            XCTAssertGreaterThanOrEqual(i, 1)
            XCTAssertLessThanOrEqual(i, 2)
        }
    }
    
    func testThatItReturnsAValidNumberWhenTheFirstArgumentIsLower() {
        
        (0...100).forEach { _ in
            // when
            let i = randomInteger(1, to: 2)
            
            // then
            XCTAssertGreaterThanOrEqual(i, 1)
            XCTAssertLessThanOrEqual(i, 2)
        }
    }
    
    func testThatEventuallyItReturnsAllNumbersOfAnInterval() {
        
        // given
        let values = Set(10...20)
        var notYetFoundValues = values

        // this test could fail if the random choice often pick the same number which, in theory, could happen.
        // But if in 1000 random choices it does not generate 10 different values, then the random number generator
        // has a very bad distribution and the test deserves to fail :)
        for _ in 0...1000 {
            // when
            let i = randomInteger(10, to: 20)
            
            // then
            XCTAssertTrue(values.contains(i))
            notYetFoundValues.remove(i)
            
            if notYetFoundValues.count == 0 {
                break
            }
        }
        
        // then
        XCTAssertEqual(notYetFoundValues.count, 0, "Did not find values: \(notYetFoundValues)")
    }

}

// MARK: - Random element
extension RandomTests {
    
    func testThatItReturnsNoneWhenPickingOneFromAnEmptyArray() {
        
        // given
        let pool = Array<Int>()
        
        // when
        let choice = pool.randomChoice()
        
        // then
        XCTAssertNil(choice)
    }
    
    func testThatItReturnsTheElementWhenPickingOneFromAnArrayOfSize1() {
        
        // given
        let pool = [42]
        
        // when
        let choice = pool.randomChoice()
        
        // then
        XCTAssertEqual(choice, 42)
    }
    
    func testThatItReturnsAllElementWhenPickingOne() {
        
        // given
        let pool = Array(1...10)
        var notYetFoundValues = Set(pool)
        
        // this test could fail if the random choice often pick the same number which, in theory, could happen.
        // But if in 1000 random choices it does not generate 10 different values, then the random number generator
        // has a very bad distribution and the test deserves to fail :)
        for _ in 0...1000 {
            // when
            let i = pool.randomChoice()!
            
            // then
            notYetFoundValues.remove(i)
            
            if notYetFoundValues.count == 0 {
                break
            }
        }
        
        // then
        XCTAssertEqual(notYetFoundValues.count, 0, "Did not find values: \(notYetFoundValues)")
    }
}

// MARK: - Random multiple elements
extension RandomTests {
    
    
    func testThatItReturnsNoElementsWhenPickingManyFromAnEmptyArray() {
        
        // given
        let pool = Array<Int>()
        
        // when
        let choice = pool.randomElements(3)
        
        // then
        XCTAssertEqual(choice, [])
    }
    
    func testThatItReturnsAllElementWhenPickingManyFromAnArrayOfSmallerSize() {
        
        // given
        let pool = ["a","b"]
        
        // when
        let choice = pool.randomElements(10)
        
        // then
        XCTAssertEqual(choice.count, 2)
        XCTAssertEqual(pool, choice.sorted())
    }
    
    func testThatItReturnsAllElementWhenPickingManyFromAnArrayOfTheExactSize() {
        
        // given
        let pool = ["a","b","c"]
        
        // when
        let choice = pool.randomElements(3)
        
        // then
        XCTAssertEqual(choice.count, pool.count)
        XCTAssertEqual(pool, choice.sorted())
    }
    
    func testThatItReturnsAllElementWhenPickingSome() {
        
        // given
        let pool = Array(1...10)
        var notYetFoundValues = Set(pool)
        
        // this test could fail if the random choice often pick the same number which, in theory, could happen.
        // But if in 1000 random choices it does not generate 10 different values, then the random number generator
        // has a very bad distribution and the test deserves to fail :)
        for _ in 0...1000 {
            // when
            let choices = pool.randomElements(5)
            
            // then
            choices.forEach { notYetFoundValues.remove($0) }
            if notYetFoundValues.count == 0 {
                break
            }
        }
        
        // then
        XCTAssertEqual(notYetFoundValues.count, 0, "Did not find values: \(notYetFoundValues)")
    }
    
    func testThatItReturnsDifferentVariationsWhenPickingSome() {
        // given
        let pool = Array(1...10)
        var foundSets = Set<String>()
        
        // this test could fail if the random choice often pick the same sequence which, in theory, could happen.
        // But if in 100 random choices it does not generate at least 5 different values, then the random number generator
        // has a very bad distribution and the test deserves to fail :)
        for _ in 0...100 {
            // when
            let choices = pool.randomElements(5)
            
            // then
            let hashable = choices.reduce("") { $0 + "-\($1)"} // combine into string so it's hashable
            foundSets.insert(hashable)
            
            if(foundSets.count == 5) {
                break
            }
        }
        
        // then
        XCTAssertEqual(foundSets.count, 5)
    }
}

// MARK: - Random multiple elements with repetitions
extension RandomTests {

    func testThatItReturnsNoElementsWhenPickingRepeatedFromAnEmptyArray() {
        
        // given
        let pool = Array<Int>()
        
        // when
        let choice = pool.randomSequence(3)
        
        // then
        XCTAssertEqual(choice, [])
    }
    
    func testThatItReturnsTheElementWhenPickingRepeatedFromAnArrayOfSizeOne() {
        
        // given
        let pool = ["a"]
        
        // when
        let choice = pool.randomSequence(10)
        
        // then
        XCTAssertEqual(choice.count, 10)
        XCTAssertEqual((1...10).map { _ in "a"}, choice)
    }
    
    func testThatItReturnsAllElementWhenPickingRepeatedlySome() {
        
        // given
        let pool = Array(1...10)
        var notYetFoundValues = Set(pool)
        
        // this test could fail if the random choice often pick the same number which, in theory, could happen.
        // But if in 1000 random choices it does not generate 10 different values, then the random number generator
        // has a very bad distribution and the test deserves to fail :)
        for _ in 0...1000 {
            // when
            let choices = pool.randomSequence(5)
            
            // then
            choices.forEach { notYetFoundValues.remove($0) }
            if notYetFoundValues.count == 0 {
                break
            }
        }
        
        // then
        XCTAssertEqual(notYetFoundValues.count, 0, "Did not find values: \(notYetFoundValues)")
    }
    
    func testThatItReturnsDifferentVariationsWhenPickingRepeatedly() {
        // given
        let pool = Array(1...10)
        var foundSets = Set<String>()
        
        // this test could fail if the random choice often pick the same sequence which, in theory, could happen.
        // But if in 100 random choices it does not generate at least 5 different values, then the random number generator
        // has a very bad distribution and the test deserves to fail :)
        for _ in 0...100 {
            // when
            let choices = pool.randomSequence(5)
            
            // then
            let hashable = choices.reduce("") { $0 + "-\($1)"} // combine into string so it's hashable
            foundSets.insert(hashable)
            
            if(foundSets.count == 5) {
                break
            }
        }
        
        // then
        XCTAssertEqual(foundSets.count, 5)
    }
}
