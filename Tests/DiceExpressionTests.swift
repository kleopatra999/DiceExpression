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

extension DiceExpression {
    
    /// Rolls the dice multiple times and verify that it is within bounds
    private func rollAndCheckResult(expectedMinimum expectedMinimum: Int, expectedMaximum: Int, expectedDifferentValues: Bool) {
        
        var previousResults: [Int:Int] = [:]
        
        for _ in 0..<100 {
            
            let result = self.roll()
            
            XCTAssertGreaterThanOrEqual(result.result, expectedMinimum)
            XCTAssertLessThanOrEqual(result.result, expectedMaximum)
            
            previousResults[result.result] = (previousResults[result.result] ?? 0) + 1
        }
        
        if expectedDifferentValues {
            XCTAssertGreaterThan(previousResults.count, 1)
        }
        else {
            XCTAssertEqual(previousResults.count, 1)
        }
    }
}



class DiceExpressionTests: XCTestCase {
    
    func testThatItRollsAConstantPositiveExpression() {
        
        // given
        let constant = 5
        let roll = try! DiceExpression("\(constant)")
        
        // then
        roll.rollAndCheckResult(expectedMinimum: constant, expectedMaximum: constant, expectedDifferentValues: false)
        XCTAssertEqual(roll.description, "\(constant)")
    }
    
    func testThatItRollsAConstantNegativeExpression() {
        
        // given
        let constant = -5
        let roll = try! DiceExpression("\(constant)")
        
        // then
        roll.rollAndCheckResult(expectedMinimum: constant, expectedMaximum: constant, expectedDifferentValues: false)
        XCTAssertEqual(roll.description, "\(constant)")

    }
    
    func testThatItRollsAConstantCompositeExpression() {
        // given
        let constant = 25
        let expression = "100-75-10+5+5"
        let roll = try! DiceExpression(expression)
        
        // then
        roll.rollAndCheckResult(expectedMinimum: constant, expectedMaximum: constant, expectedDifferentValues: false)
        XCTAssertEqual(roll.description, expression)

    }
    
    func testThatItRollADiceExpression() {
        
        // given
        let expression = "3d6"
        let roll = try! DiceExpression(expression)
        
        // then
        roll.rollAndCheckResult(expectedMinimum: 3, expectedMaximum: 18, expectedDifferentValues: true)
        XCTAssertEqual(roll.description, expression)
    }
    
    func testThatItRollACompositeDiceExpression() {
        
        // given
        let expression = "-100+2d6+1d6"
        let roll = try! DiceExpression(expression)
        
        // then
        roll.rollAndCheckResult(expectedMinimum: -97, expectedMaximum: -82, expectedDifferentValues: true)
        XCTAssertEqual(roll.description, expression)

    }
    
    func testThatItThrowsWhenExpressionHasTwoSigns() {
        
        // given
        let expressions = ["--6", "++6", "1d6+-4"]
        
        // when
        for expression in expressions {
            do {
                let _ = try DiceExpression(expression)
                XCTFail()
            }
            catch DiceExpression.ParsingError.CanNotEndWithToken {
            }
            catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }
    
    func testThatItThrowsWhenEndsWithSign() {
        
        // given
        let expressions = ["3+", "1d6-"]
        
        // when
        for expression in expressions {
            do {
                let _ = try DiceExpression(expression)
                XCTFail()
            }
            catch DiceExpression.ParsingError.CanNotEndWithToken {
            }
            catch {
                XCTFail("Unexpected")
            }
        }
    }
    
    func testThatItThrowsWhenNotAValidDieToken() {
        
        // given
        let expressions = ["3+x", "1d6-3h5"]
        
        // when
        for expression in expressions {
            do {
                let _ = try DiceExpression(expression)
                XCTFail()
            }
            catch DiceExpression.ParsingError.NotAValidToken {
            }
            catch {
                XCTFail("Unexpected")
            }
        }
    }
}


// MARK: Operations
extension DiceExpressionTests {
    
    func testThatItAddsTwoExpressions() {
        
        // given
        let left = try! DiceExpression("10+3")
        let right = try! DiceExpression("4+2-3")
        
        // when
        let result = left + right
        
        // then
        XCTAssertEqual(result.description, "10+3+4+2-3")
        XCTAssertEqual(result.roll().result, 16)
    }
    
    func testThatItSubtractsTwoExpressions() {
        
        // given
        let left = try! DiceExpression("13")
        let right = try! DiceExpression("4+2-3")
        
        // when
        let result = left - right
        
        // then
        XCTAssertEqual(result.description, "13-4-2+3")
        XCTAssertEqual(result.roll().result, 10)
    }

}

