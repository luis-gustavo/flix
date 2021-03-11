//
//  FXScreen.swift
//  Storyteller
//
//  Created by Gustavo Amaral on 10/05/19.
//  Copyright © 2019 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import Foundation

/**
 The object (like a SKScene, UIViewControler or something like that) responsible for presenting the current game.
 
 After adopting this protocol and setting up the requiriments, you should call `startWatchNow()` when the game is ready
 to be played and before watching the first episode.
 */
public protocol FXScreen: AnyObject {
    /// Used to communicate with the instance responsible for handling presentation logic.
    var screenDelegate: FXScreenDelegate? { get set }
}

extension FXScreen {
    /// Signs to the FXSeries that it can starts watching episodes and receving chunks of data.
    /// Futhermore, perform some setup logic like calling delegate methods.
    ///
    /// This is just a shortcut for the method with the same signature in `screenDelegate` property.
    public func startWatchNow() {
        self.screenDelegate?.startWatchNow()
    }
    
    #warning("Document this method")
    public func stopWatchNow() {
        self.screenDelegate?.stopWatchNow()
    }
}
