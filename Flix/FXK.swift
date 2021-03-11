//
//  STK.swift
//  Storyteller
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 09/05/19.
//  Copyright © 2019 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import Foundation
import UIKit

/**
 A namespace used to hold constant and functionally generated data.

 It's also useful to avoid using the same string in two different places.
 */
struct FXK {

    private init() { }

    /// Strings used on error messages. Some properties are in really
    /// functions that you can call to generate a custom string.
    struct ErrorMessage {
        private init() { }

        static let seasonsAreEmpty = "Every story must have chapters."
        static let seasonDidTimeout: (FXSeries, FXNumber) -> String = { series, seasonIndex in
            return "Series: \(series) did timeout at season of index: \(seasonIndex)"
        }
        static let mustHaveSettings = "The settings must be setted."
        static let noCurrentSeason = "SeasonsSequence contains no current season"
        
        static let reachedTheEnd = "You are trying to decide after the hall has reached the end."
        static let sceneIsNotFXScreen = "The scene isn't if type FXScreen"
        static let controllerIsNotFXScreen = "The controller isn't if type FXScreen"
        static let unsettedDelegate: (String) -> String = { delegate in
            return "The \(delegate) isn't setted"
        }
        static let superclassInitializedCalled = "The initializer \(#function) must be called on the subclass"
        static let mustHaveSeasonsSequence = "The series must have a SeasonsSequence"
        static let mustCallStartWatchNow = "You must call startWatchNow() method from FXScreen before start sending events"
        static let historyCompletionMustBeDefined = "The history completion must be defined for every series."
        static let viewControllerNotFound: (UIView) -> String = { view in return "UIViewController of the view \(view) not found" }
        static let noTopMostController = "There's no current controller"
        static let unableToCreateTimer = "The timer can't be created because the FXSettings instance doesn't adopt FXTimedSettings"
        static let missingDelegateWhenSkippingSeason = "There must be a delegate to skip the season to the end."
    }
    
    struct WarningMessage {
        private init() { }
        
        static let episodeDiscarded = "Episode discarded because already there's one being watched"
    }

    /// Queues used on the framework.
    struct Queue {
        private init() { }
        static let season = DispatchQueue(label: "br.com.bepiducb.Storyteller.season")
    }
    
    /// Data created just for debugging purposes.
    struct Debug {
        private init () { }
        static let watchDataDescription: (FXWatchData) -> String = { data in
            return "\(data.when): \(data.what) at \(data.where)"
        }
    }
    /// Keys used when when storing and retrieving data used the 3W Data Pattern.
    struct WatchData {
        private init() { }
        
        static let seasonStarted = "SeasonStarted"
        static let seasonEnded = "SeasonEnded"
        static let timeoutOccured = "TimeoutOccured"
        static let timeoutTimerStarted = "timeoutTimerStarted"
        static let seriesSkippedToTheEnd = "SeriesSkippedToTheEnd"
        static let seasonSkippedToTheNext = "SeasonSkippedToTheNext"
    }

}
