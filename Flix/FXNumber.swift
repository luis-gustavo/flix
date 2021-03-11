//
//  FXNumber.swift
//  Flix
//
//  Created by Gustavo Amaral on 03/06/19.
//  Copyright © 2019 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import Foundation

/**
 An index that's more convenient to use when doing comparisons.
 
 A season is almost a inexistent data type. It's more useful when building a game
 to know what's season's index than the object itself. So this type is used so
 you can do things like:
 
     if season == .first {
         // Do something...
     }
 
 or
 
     if season == .lastButOne {
        //Do something...
     }
 
 This enum doesn't cover all the cases, so in some situations you need to get the index
 using the `middle(_ index: Int)` case. To do that, you can use *pattern matching* like this:
 
        switch season {
        case .middle(index: let index):
                print("The season index is \(index)")
        default:
                print("Cannot the season's index")
        }
 
 When the case isn't `middle(_ index: Int)` you can't access the index number as an Int.
 
 */
public enum FXNumber {
    /// Used when the season if the first from the current series.
    case first
    /// Used when the season index isn't any of the other cases.
    ///
    /// You can do *pattern matching* to extract the index.
    case middle(_ index: Int)
    /// Used the the season index is the previous of the last in the series.
    case lastButOne
    /// Used when the season index is the last of the series.
    case last
    
    /// Create a new season's number with the correct case using the current index
    /// and the total number fo seasons in the series.
    init(_ index: Int, _ numberOfSeasons: Int) {
        if index == 0 && numberOfSeasons > 1 { self = .first }
        else if index == numberOfSeasons - 1 { self = .last }
        else if index == numberOfSeasons - 2 { self = .lastButOne}
        else { self = .middle(index) }
    }
}

extension FXNumber: Equatable {
    
    public static func ==(lhs: FXNumber, rhs: FXNumber) -> Bool {
        switch lhs {
        case .first:
            switch rhs {
            case .first: return true
            default: return false
            }
        case .middle(index: let leftIndex):
            switch rhs {
            case .middle(index: let rightIndex): return leftIndex == rightIndex
            default: return false
            }
        case .last:
            switch rhs {
            case .last: return true
            default: return false
            }
        case .lastButOne:
            switch rhs {
            case .lastButOne: return true
            default: return false
            }
        }
    }
}
