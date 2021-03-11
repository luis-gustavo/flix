//
//  FXWatchData.swift
//  Flix
//
//  Created by Gustavo Amaral on 31/05/19.
//  Copyright © 2019 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import Foundation

/**
 A chunk of data that represents something that happened in the game. Normally
 this chunks are created by user's interactions.
 
 - Warning: you should create an instance of this type immediately after the data
 happened.
 
 This type implements the 3W Data Pattern used to generalized all data recorded
 for every game. So you should read about that documentation to know how to
 create instances of this type.
 
 When you create a chunk, the **when** is created inside the initializer automatically.
 */
public struct FXWatchData {
    /// An unique 3W identifer with a greate semantics about what has happened.
    public let what: String
    /// A timestamp for when the data chunk was generated.
    public let when: Date
    /// A hierarchy tree with the event's address.
    public let `where`: String
    
    /// Create a new chunk of data to be added on the history later. The default value for `when` is now.
    public init(what: String, where: String) {
        self.init(what: what, when: Date(), where: `where`)
    }
    
    /// Create a new chunk of data to be added on the history later.
    private init(what: String, when: Date, where: String) {
        self.what = what
        self.when = when
        self.where = `where`
    }
    
    /**
     Create a copy of this instance by adding a time interval to the current `when` value.
     
     - Parameter timeInterval: time to be added to this value.
     - Returns: a new watch data with the incremented `when` value.
     */
    func adding(_ timeInterval: TimeInterval) -> FXWatchData {
        let advancedDate = self.when.addingTimeInterval(timeInterval)
        return FXWatchData(what: what, when: advancedDate, where: `where`)
    }
}

extension FXWatchData: CustomStringConvertible {
    public var description: String {
        return FXK.Debug.watchDataDescription(self)
    }
}
