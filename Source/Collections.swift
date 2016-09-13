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

enum CollectionClusteringError : Error {
    
    /// When clustering a collection, the size of the collection was not a multiple of the cluster size
    case sizeIsNotMultipleOfClusterSize
}

extension Collection where IndexDistance == Int, Index == Int {
    
    /**
     Returns an array of elements from the collection grouped in clusters of the given size, 
        grouped according to the original order in the collection
     
     E.g.
     ```
     let array = [1,2,3,4,5,6]
     let groups = array.groupedArray(3) // -> [[1,2,3],[4,5,6]]
     ```

     - Parameter clusterSize: The size of the clustering
     
     - Returns: An array of arrays, with each sub-array representing a cluster with the given size
     
     - Throws: `CollectionGroupingError.SizeIsNotMultipleOfGroupSize` if the size of the collection is not a multiple of the cluster size
     
    */
    func groupedArray(_ clusterSize: Int) throws -> [[Iterator.Element]] {
        
        guard (self.count % clusterSize) == 0 else { throw CollectionClusteringError.sizeIsNotMultipleOfClusterSize }
    
        let numberOfGroups = self.count / clusterSize
        let groupIndexes = (0..<numberOfGroups)
        
        return groupIndexes.map {
            let baseIdx = $0 * clusterSize
            return (baseIdx..<baseIdx+clusterSize).map {
                self[$0]
            }
        }
    }
}
