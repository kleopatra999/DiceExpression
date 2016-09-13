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

/// A table of weights and choices, where weights are going to be used to perform
/// a random selection
public struct RandomTable<Choice> {
    
    public typealias ChoiceWeight = (weight: UInt32, choice: Choice)
    
    /// The table of choices and weights
    public let table : [ChoiceWeight]
    
    /// Total weight for all choices in the table
    fileprivate let totalWeight : UInt32
    
    /// Creates a random table from a list of choices and weights.
    /// - warning: the sum of all the weights must be less than the maximum
    ///     value of UInt, or an overflow will occur
    public init(choicesAndWeights: [ChoiceWeight]) {
        self.table = choicesAndWeights
        self.totalWeight = choicesAndWeights.reduce(0) {
            $0 + $1.weight
        }
    }
}

extension RandomTable {
    
    /// Returns a random element from the table
    public func select() -> Choice? {
        guard !table.isEmpty && totalWeight > 0 else {
            return nil
        }
        let roll = arc4random_uniform(self.totalWeight)+1
        var weightSoFar : UInt32 = 0
        for weightChoice in self.table {
            weightSoFar += weightChoice.weight
            if weightSoFar >= roll {
                return weightChoice.choice
            }
        }
        fatalError()
    }
}
