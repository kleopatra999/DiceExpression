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

/**
 A value type modeling the result of an operation.
 It encapsulating the result value and a log describing how the calculation was done.
*/
public struct ResultWithLog<ResultType> {
    
    /// The value of the result
    public let result : ResultType
    
    /// The logs associated with the result
    public let logs : String
    
    /**
     Creates a result with a log
    */
    public init(result : ResultType, log : String) {
        self.result = result
        self.logs = log
    }
    
    /** 
     Creates a result with multiple logs
     
     - Param: logs multiple logs that will be concatenated into one
     
    */
    public init<S: SequenceType where S.Generator.Element == String>(result : ResultType, logs: S) {
        self.result = result
        self.logs = logs.reduce("") { "\($0)\($1)\n"}
    }
}