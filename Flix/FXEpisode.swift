//
//  FXEpisode.swift
//  Storyteller
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 09/05/19.
//  Copyright © 2019 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import Foundation

/**
 Used as a funnel where you can customized the game's logic and perform chained actions when some episode is watched/event is sent.
 
 This is the main type of the framework. Even though it is a protocol, it was created to be used as an enumeration where each case
 represents an episode. So your implementation is a bucket if episodes that can or not be called in order.
 
 Futhermore, you can also implements lifecyle methods to know when a season starts or ends. You have all the information you will need
 to perform some logic in
 
     func viewer(_: FXViewer, wannaWatch: FXEpisode, from: FXNumber, at: FXScreen, with: FXSettings, afterFinish: @escaping (FXWhatNext) -> Void)
 
 method.
 */
public protocol FXEpisode {
    #warning("Try to implement equatable")
    func isEqual(rhs: FXEpisode) -> Bool
    
    /**
     Called when an episode will be watched by a viewer. The viewer is an entity on screen and the episode is an event that must handled.
     
     After you finish handling the episode, you must call this method to allow you receive more events. All events sent when an episode is being
     handled are ignored.
     
     
     - Parameter viewer: The object that has thrown the episode event.
     - Parameter episode: What episode should be executed.
     - Parameter season: The season that is being executed.
     - Parameter screen: Where the game is being executed.
     - Parameter setting: Configuration used to present the series and some more logic.
     - Parameter afterFinish: a closure that must be called when you finish handling this episode.
     - Parameter whatNext: what should happen after this episode is handled.
     */
    func viewer(_ viewer: FXViewer, wannaWatch episode: FXEpisode, from season: FXNumber, at screen: FXScreen, with settings: FXSettings, afterFinish: @escaping (_ whatNext: FXWhatNext) -> Void)
}

/**
 You can use this enum to inform if you need to leave this season or stay on it.
 
 If you leave the current season and this season is the last the FXSeries will end and other delegate methods will be called subsequently.
 */
public enum FXWhatNext {
    // You should use this case whenever you want to do some more game logic within the current season.
    case stayOnSeason
    // You should use this case whenever the current season ends and you need to go to the next.
    case leaveSeason
    // You should use this case whenever you'd like to get out the current series aborting the game.
    case skipToEnd
}
