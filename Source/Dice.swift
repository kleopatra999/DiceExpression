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

/// A die with faces, which can be rolled multiple times
public struct Dice : Rollable, CustomStringConvertible {
    
    /// Number of faces on the die (e.g. 6 for a cubic, 1-to-6 die)
    public let faces: UInt32
    
    /// Number of rolls for this die (e.g. 2 if rolling the die twice and adding the results)
    public let repetitions: UInt32
    
    /// Dice expression used to calculate the roll result
    private let expression : DiceExpression
    
    /// - param faces: number of faces on the die (e.g. 6 for a cubic, 1-to-6 die)
    /// - param repetitions: number of rolls for this die (e.g. 2 if rolling the die twice and adding the results)
    public init(faces: UInt32, repetitions: UInt32 = 1) {
        self.faces = faces
        self.repetitions = repetitions
        self.expression = DiceExpression(tokens: [
            SignedDiceExpressionComponent(
                sign: Sign.Plus,
                component: DiceExpressionComponent.dice(faces: self.faces, repetitions: self.repetitions
                ))
            ])
    }
    
    public func roll() -> ResultWithLog<Int> {
        return self.expression.roll()
    }
    
    public var description: String {
        return self.expression.description
    }
}

/// A coin (two-sided die)
public let D2 = Dice(faces: 2)
/// A die with 4 faces, a tetrahedron
public let D4 = Dice(faces: 4)
/// A die with 6 faces, a cube
public let D6 = Dice(faces: 6)
/// A die with 8 faces, an octahedron
public let D8 = Dice(faces: 8)
/// A die with 10 faces, a decahedron
public let D10 = Dice(faces: 10)
/// A die with 12 faces, a dodecahedron
public let D12 = Dice(faces: 12)
/// A die with 20 faces, an icosahedron
public let D20 = Dice(faces: 20)
/// A die with 100 faces, also known as "percentage die"
public let D100 = Dice(faces: 100)
