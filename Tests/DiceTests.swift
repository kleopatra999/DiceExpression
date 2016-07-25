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

let testRepetition = 0..<100

class DiceTests: XCTestCase {
}

// MARK: - Custom dice rolls
extension DiceTests {
    
    func testThatADiceWithZeroFacesRollsZero() {
        
        testRepetition.forEach { _ in
            // given
            let die = Dice(faces: 0)
            
            // when
            let result = die.roll().result
            
            // then
            XCTAssertEqual(result, 0)
        }
    }
    
    func testThatADiceWithOneFaceRollsOne() {
        
        // given
        var total = 0
        let die = Dice(faces: 1)
        
        // when
        (0..<100).forEach { _ in
            total += die.roll().result
        }
        
        // then
        XCTAssertEqual(total, 100)
    }
    
    func testMultipleRoolsOfADiceWithOneFace() {
        
        // given
        let die = Dice(faces: 1, repetitions: 100)
        
        // when
        let roll = die.roll().result
        
        // then
        XCTAssertEqual(roll, 100)
    }
    
    func testThatItRollsMultipleDice() {
        
        // given
        let die = Dice(faces: 3, repetitions: 10)
        
        // when
        let roll = die.roll().result
        
        // then
        XCTAssertTrue((10...30).contains(roll))
    }
}

// MARK: - Predefined dice
extension DiceTests {
    
    func testD2() {
        testRepetition.forEach { _ in
            XCTAssertTrue((1...2).contains(D2.roll().result))
        }
    }
    
    func testD4() {
        testRepetition.forEach { _ in
            XCTAssertTrue((1...4).contains(D4.roll().result))
        }
    }
    
    func testD6() {
        testRepetition.forEach { _ in
            XCTAssertTrue((1...6).contains(D6.roll().result))
        }
    }
    
    func testD8() {
        testRepetition.forEach { _ in
            XCTAssertTrue((1...8).contains(D8.roll().result))
        }
    }
    
    func testD10() {
        testRepetition.forEach { _ in
            XCTAssertTrue((1...10).contains(D10.roll().result))
        }
    }
    
    func testD12() {
        testRepetition.forEach { _ in
            XCTAssertTrue((1...12).contains(D12.roll().result))
        }
    }
    
    func testD20() {
        testRepetition.forEach { _ in
            XCTAssertTrue((1...20).contains(D20.roll().result))
        }
    }
    
    func testD100() {
        testRepetition.forEach { _ in
            XCTAssertTrue((1...100).contains(D100.roll().result))
        }
    }
}

// MARK: - Description
extension DiceTests {
    
    func testThatTheDescriptionMatches() {
        XCTAssertEqual("1d2", D2.description)
        XCTAssertEqual("1d4", D4.description)
        XCTAssertEqual("1d6", D6.description)
        XCTAssertEqual("1d8", D8.description)
        XCTAssertEqual("1d10", D10.description)
        XCTAssertEqual("1d12", D12.description)
        XCTAssertEqual("1d20", D20.description)
        XCTAssertEqual("1d100", D100.description)
        XCTAssertEqual("3d6", Dice(faces: 6, repetitions: 3).description)
    }
}