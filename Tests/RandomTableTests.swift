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

class RandomTableTests: XCTestCase {
}

// MARK: - Nil choices
extension RandomTableTests {
    
    func testThatItReturnsNoChoiceOnEmptyTable() {
        
        // given
        let table = RandomTable<String>(choicesAndWeights: [])
        
        // when
        let choice = table.select()
        
        // then
        XCTAssertNil(choice)
    }
    
    func testThatItReturnsNoChoiceOnTableWithZeroWeights() {
        
        // given
        let choices = [
            (weight: UInt32(0), choice: "a"),
            (weight: UInt32(0), choice: "b")
        ]
        let table = RandomTable<String>(choicesAndWeights: choices)
        
        // when
        let choice = table.select()
        
        // then
        XCTAssertNil(choice)
    }
}

// MARK: - Select a choice
extension RandomTableTests {
    
    func testThatItReturnsAChoiceFromOneChoice() {
        
        // given
        let oneChoice = "aaa"
        let choices = [
            (weight: UInt32(1), choice: oneChoice)
        ]
        let table = RandomTable<String>(choicesAndWeights: choices)
        
        // when
        let choice = table.select()
        
        // then
        XCTAssertEqual(choice, oneChoice)
        
    }
    
    func testThatItReturnsAChoiceFromAListOfChoices() {
        
        // given
        let choice1 = "aaa"
        let choice2 = "foo"
        let choice3 = "---"
        let choiceList = Set([choice1, choice2, choice3])
        let choices = [
            (weight: UInt32(1), choice: choice1),
            (weight: UInt32(20), choice: choice2),
            (weight: UInt32(8), choice: choice3)
        ]
        let table = RandomTable<String>(choicesAndWeights: choices)
        
        // when
        guard let choice = table.select() else {
            XCTFail()
            return
        }
        
        // then
        XCTAssertTrue(choiceList.contains(choice))
    }
    
    func testThatItEventuallyReturnsAChoiceWithVeryHighWeight() {
        
        // given
        let likelyChoice = "I have '(UInt32.max-2) / UInt32.max' chances of being selected!"
        let choices = [
            (weight: 1, choice: "foo"),
            (weight: UInt32.max-2, choice: likelyChoice),
            (weight: 1, choice: "bar")
        ]
        let table = RandomTable<String>(choicesAndWeights: choices)
        
        // when
        let choice = table.select()
        
        // then
        // unless you are very unlucky, this test should pass.
        // how unlucky? Approx 99.999999953433871% of the times this test should pass
        XCTAssertEqual(choice, likelyChoice)
    }
}
