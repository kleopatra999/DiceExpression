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

import Foundation



// MARK: - Public

/**
 Value type modeling a dice expression.
A dice expression is a combination of additions on constant numbers ("2+3")
and dice rolls ("1d6"). Dice rolls are expressed in the following notation:

`<times>d<die>`

where:
* `times` is an unsigned intereger, the number of time the die is rolled
* `die` is an unsigned integer, the maximum value that the die can return (so the result is
a random number between 1 and `die`)
* the final result is the sum of the result of the individual rolls

Thus "2d6" means that a normal six-sided die should be rolled twice and
the two results added. The final result varies between 2 and 12.

"1d20+10" means that a 20-sided dice is rolled, and 10 is added. The
final result varies between 11 and 30.
*/

public struct DiceExpression : CustomStringConvertible, Rollable {
    
    /// The expression in string form (e.g. "1d10+4")
    public var description : String { return components.expression }
    
    /// Individual die expressions that form the final expression
    fileprivate let components : [SignedDiceExpressionComponent]
    
    public enum ParsingError : Error {
        /// Unable to parse a specific token of the expression
        case notAValidToken(token: String)
        /// Two tokens can't be consecutive. E.g. there can't be two "+ +"
        case tokenCanNotFollowToken(token1: String, token2: String)
        /// The expression can't end with this token. E.g. an expression can't end with "+"
        case canNotEndWithToken(token: String)
    }
    
    /**
        Parse a dice expression in string form

        - throws: DiceExpression.ParsingError if the expression was malformed
    */
    public init(_ expression : String) throws {
        self.components = try parseSignAndRollTokens(expression.diceExpressionStringTokens)
    }
    
    /** 
        Roll all dice, sum the results and constants and return the final roll result
        Multiple invocations of this method might return a different value, as dice are
        re-rolled at every invocation
     */
    public func roll() -> ResultWithLog<Int> {
        var total = 0
        for signedDiceExpression in self.components {
            total += signedDiceExpression.sign.apply(signedDiceExpression.component.roll())
        }
        
        return ResultWithLog<Int>(result: total, log: self.description);
    }
}

// MARK: Operators

/// Concatenate the second dice expression to the first dice expression
public func +(lhs: DiceExpression, rhs: DiceExpression) -> DiceExpression {
    return DiceExpression(tokens: lhs.components + rhs.components)
}

/// Concatenate the inverse of the second dice expression to the first dice expression
public func -(lhs: DiceExpression, rhs: DiceExpression) -> DiceExpression {
    return DiceExpression(tokens: lhs.components + rhs.components.map {
            SignedDiceExpressionComponent(sign: $0.sign.invert(), component: $0.component)
        })
}



// MARK: - Private implementation

/// A sign and a die roll
struct SignedDiceExpressionComponent {
    let sign : Sign
    let component: DiceExpressionComponent
}

extension Sequence where Iterator.Element == SignedDiceExpressionComponent {
    fileprivate var expression : String {
        let fullString = self.reduce("") { $0 + $1.sign.description + $1.component.description }
        if fullString.hasPrefix(Sign.Plus.rawValue) {
            return fullString.substring(from: fullString.characters.index(fullString.startIndex, offsetBy: Sign.Plus.rawValue.characters.count)) // remove initial "+" if present
        }
        return fullString
    }
}


extension DiceExpression {
    
    /// Initializes from already parsed signed dice expression components
    init(tokens: [SignedDiceExpressionComponent]) {
        self.components = tokens
    }
}

/// From array of strings to tokens
private func parseSignAndRollTokens(_ array: [String]) throws -> [SignedDiceExpressionComponent] {
    guard let firstElement = array.first else { return [] }

    let needToPrependPlusSign = Sign(rawValue: firstElement) == nil // not a sign
    
    let arrayWithSign = (needToPrependPlusSign ? [Sign.Plus.rawValue] : []) + array
    
    guard let tuples = try? arrayWithSign.groupedArray(2) else {
        throw DiceExpression.ParsingError.canNotEndWithToken(token: arrayWithSign.last!)
    }

    return try tuples.map { tuple in
        guard let sign = Sign(rawValue: tuple[0]) else {
            throw DiceExpression.ParsingError.notAValidToken(token: tuple[0])
        }
        if let _ = Sign(rawValue: tuple[1]) {
            throw DiceExpression.ParsingError.tokenCanNotFollowToken(token1: tuple[0], token2: tuple[1])
        }
        guard let component = DiceExpressionComponent(tokenExpression: tuple[1]) else {
            throw DiceExpression.ParsingError.notAValidToken(token: tuple[1])
        }
        return SignedDiceExpressionComponent(sign: sign, component: component)
    }
    
}

/// Operations
enum Sign : String  {
    case Plus = "+"
    case Minus = "-"
    
    /// Applies the sign to a value
    func apply(_ value: Int) -> Int {
        switch(self) {
        case .Plus: return value
        case .Minus: return -value
        }
    }
    
    /// Inverts the sign
    func invert() -> Sign {
        switch(self) {
        case .Plus: return .Minus
        case .Minus: return .Plus
        }
    }
    
    var description : String {
        return self.rawValue
    }
}

/// An individual token inside a dice expression
enum DiceExpressionComponent {
    
    /// A proper dice roll, such as 3d6
    case dice(faces: UInt32, repetitions: UInt32)
    
    /// A constant int value
    case constant(value: Int)
    
    /// Roll and returns result
    func roll() -> Int {
        switch(self) {
        case let .dice(faces, repetitions):
            var total = 0
            for _ in 0..<repetitions {
                if faces > 0 {
                    total += Int(arc4random_uniform(faces))+1
                }
            }
            return total
        case let .constant(value):
            return value
        }
    }
    
    /// Creates a dice token
    init?(tokenExpression: String) {
        if let constantValue = Int(tokenExpression) {
            self = .constant(value: constantValue)
            return
        }
        else {
            let splitted = tokenExpression.components(separatedBy: "d")
            if(splitted.count != 2) {
                return nil
            }
            if let faces = UInt32(splitted[1]), let repetitions = UInt32(splitted[0]) {
                self = .dice(faces: faces, repetitions: repetitions)
                return
            }
            else {
                return nil
            }
        }
    }
    
    var description : String {
        switch(self) {
        case let .dice(faces, repetitions):
            return "\(repetitions)d\(faces)"
        case let .constant(value):
            return "\(value)"
        }
    }
}



extension String {
    
    /// Splits a string into parsing tokens
    fileprivate var diceExpressionStringTokens : [String] {
        var buffer = ""
        var foundTokens : [String] = []
        for c in self.lowercased().characters {
            switch(c) {
            case " ": fallthrough
            case "\t":
                continue
            case "+": fallthrough
            case "-":
                if buffer.characters.count > 0 {
                    foundTokens.append(buffer)
                    buffer = ""
                }
                foundTokens.append("\(c)")
            default:
                buffer += "\(c)"
            }
        }
        if buffer.characters.count > 0 {
            foundTokens.append(buffer)
            buffer = ""
        }
        return foundTokens
    }
}
