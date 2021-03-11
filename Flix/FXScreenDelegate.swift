//
//  STEventEmitterDelegate.swift
//  Storyteller
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 09/05/19.
//  Copyright © 2019 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import Foundation

/**
 Used by FXScreen to communcate with the FXSeries.
 */
public protocol FXScreenDelegate {
    
    /// Signs to the FXSeries that it can starts watching episodes and receving chunks of data.
    /// Futhermore, perform some setup logic like calling delegate methods.
    func startWatchNow()
    
    #warning("Document this method")
    func stopWatchNow()
    
    /**
     This method should be called when a viewer wanna watch an episode and store some chunk of data. You can call this method directly or
     use method from FXViewer. They are just a shortcut for this method.
     
     Whenever you call this method, the season's timeout time will be reset, if there's one.
     
     - Parameter viewer: The object that has thrown the episode event.
     - Parameter episode: What episode should be executed.
     - Parameter screen: Where the game is being executed.
     - Parameter data: what should be added on the history to generate informations to the researchers.
     */
    func viewer(_ viewer: FXViewer, wannaWatch episode: FXEpisode, at screen: FXScreen, generating data: FXWatchData)

    /**
     This method should be called to store some chunk of data.

     - Parameter screen: Where the game is being executed.
     - Parameter data: what should be added on the history to generate informations to the researchers.
     */
    func screen(_ screen: FXScreen, didGenerate data: FXWatchData)
}
