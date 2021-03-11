//
//  FXSeasonsSequenceDelegate.swift
//  Flix
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 24/05/19.
//  Copyright © 2019 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import Foundation

/**
 Contains methods used for communication between `FXSeasonSequence` and `FXSeries`.
 */
protocol FXSeasonsSequenceDelegate: AnyObject {
    
    /**
     Called when the sequence ends executing all seasons in the series.
     
     - Parameter sender: `FXSeasonsSequence` instance calling this method.
     */
    func seasonsSequenceDidEnd(_ sender: FXSeasonsSequence)
    
    /**
     Called when a season ends it's execution.
     
     - Parameter sender: `FXSeasonsSequence` instance calling this method.
     - Parameter season: The season that has just ended.
     */
    func seasonsSequence(_ sender: FXSeasonsSequence, didEndSeason season: FXNumber)
    
    /**
     Called when the sequence starts executing all seasons in the series.
     
     - Parameter sender: `FXSeasonsSequence` instance calling this method.
     - Parameter season: The season that has just started.
     */
    func seasonsSequence(_ sender: FXSeasonsSequence, didStartSeason season: FXNumber)
    
    /**
     Called when the sequence starts need that a timer to be set for limiting how much
     time a viewer can be ona season.
     
     - Parameter sender: `FXSeasonsSequence` instance calling this method.
     */
    func seasonsSequenceNeedStartTheTimer(_ sender: FXSeasonsSequence)
    
    /**
     Called whenever a season did begin. You can use it as a customization point the repaint the screen when season starts.
     
     - Parameter season: The season that has just started.
     - Parameter screen: Where the game is being executed.
     - Parameter setting: Configuration used to present the series and some more logic.
     */
    func season(_ season: FXNumber, didStartAt screen: FXScreen, with settings: FXSettings, createTimer: @escaping () -> Void)
    
    /**
     Called whenever a season did end. You can use it as for example to present a congratulations message who is playing the game.
     
     - Parameter season: The season that has just started.
     - Parameter screen: Where the game is being executed.
     - Parameter setting: Configuration used to present the series and some more logic.
     - Parameter watchNext: called when you are ready to present the next season. If you override this method you must call this
     closure or the next season will never start. The method's default implementation call that closure automatically.
     */
    func season(_ season: FXNumber, didEndAt screen: FXScreen, with settings: FXSettings, watchNext: @escaping () -> Void)
}
