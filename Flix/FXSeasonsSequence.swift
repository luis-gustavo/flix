//
//  FXSeasonsSequence.swift
//  Flix
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 24/05/19.
//  Copyright © 2019 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import Foundation

/**
 This is virtually a delegate of `FXSeries` used to iterate over seasons and
 dispatch events for episodes.
 
 When dispatching events only one event is handled at the same time. If an event
 is thrown before the previous ends, that event is ignored.
 */
class FXSeasonsSequence {
    /// All seasons that this sequence should execute in order.
    let seasons: [FXSeason]
    
    /// Holds the current executing season.
    var currentSeason: FXSeason {
        return self.seasons[self.seasonIndex]
    }
    
    /// Cursor used to track what season is currently being executed.
    private(set) var seasonIndex = 0
    
    /// A convenience read-only variable used to hold the current season.
    var currentSeasonNumber: FXNumber {
        return FXNumber(self.seasonIndex, self.seasons.count)
    }
    
    /// Interval variable used to avoid executing two episodes at the same time.
    private var _receivingData = true
    
    /// Interval thread-safe variable used to avoid executing two episodes at the same time.
    private var receivingData: Bool {
        set {
            FXK.Queue.season.sync { _receivingData = newValue }
        }
        get {
            return _receivingData
        }
    }
    
    /// The object that acts as the delegate of the `FXSeasonsSequence`.
    weak var delegate: FXSeasonsSequenceDelegate?
    
    /// Used to avoid executing an episode after the series has reached the end.
    private var reachedTheEnd = false

    /// Initializes and returns a `FXSeasonsSequence` object.
    init(_ seasons: [FXSeason]) {
        self.seasons = seasons
    }
    
    /**
     Called by `FXSeries` to notify when the episode handling logic could start.
     
     This method is useful because some delegates methods are called before even
     the first episode is executed.
     
     - Parameter screen: Where the game is being executed.
     - Parameter setting: Configuration used to present the series and some more logic.
     */
    func startFirstSeason(at screen: FXScreen, with settings: FXSettings) {
        self.delegate?.seasonsSequence(self, didStartSeason: self.currentSeasonNumber)
        self.delegate?.season(self.currentSeasonNumber, didStartAt: screen, with: settings) {
            self.delegate?.seasonsSequenceNeedStartTheTimer(self)
        }
    }

    /**
     Delegated by `FXSeries` used to send an event to an episode and allow the user
     implements it's on handling logic.
     
     This method ignores an episode event if it's sent before the previous finishes.
     Also if this methods is called after the last season has ended, a `fatalError`
     occurs.
     
     - Parameter viewer: The object that has thrown the episode event.
     - Parameter episode: What episode should be executed.
     - Parameter screen: Where the game is being executed.
     - Parameter setting: Configuration used to present the series and some more logic.
     */
    func viewer(_ viewer: FXViewer, wannaWatch episode: FXEpisode, at screen: FXScreen, with settings: FXSettings) {

        // Avoids executing episodes after the series ends
        guard !reachedTheEnd else { fatalError(FXK.ErrorMessage.reachedTheEnd) }
        
        // Avoids executing two or more episodes at the same time
        guard self.receivingData else {
            print(FXK.WarningMessage.episodeDiscarded)
            return
        }
        self.receivingData = false
        
        // Ensures that the sent episode is in the current season
        guard self.currentSeason.contains(where: { $0.isEqual(rhs: episode )}) else { return }
        
        // Gives the opportunity to the episode handle the event
        episode.viewer(viewer, wannaWatch: episode, from: self.currentSeasonNumber, at: screen, with: settings) { whatNext in
            switch whatNext {
            case .stayOnSeason: break
            case .leaveSeason:
                self.leaveSeason(screen, settings)
            case .skipToEnd:
                self.skipToTheEnd(screen, settings)
            }
            self.receivingData = true
        }
    }
    
    /**
     Skip seasons given the argument on the skipping mode. All the delegates methods are called gracefully when skipping
     the season.
     
     - Parameter skipping: how the skipping should be made.
     - Parameter screen: where the series is being watched.
     - Parameter settings: configuration used to load the series.
     */
    func skip(_ skipping: FXSeasonSkipping, _ screen: FXScreen, _ settings: FXSettings) {
        switch skipping {
        case .toTheEnd:
            self.skipToTheEnd(screen, settings)
        case .toTheNext:
            self.skipToTheNext(screen, settings)
        case .by(amount: let quantity):
            (1...quantity).forEach { _ in self.skipToTheNext(screen, settings) }
        }
    }
    
    #warning("Documentar")
    private func leaveSeason(_ screen: FXScreen, _ settings: FXSettings) {
        #warning("Escrever mensagem de erro")
        guard let series = self.delegate as? FXSeries else { fatalError("fsdfa") }
        
        series.killTimeoutTimer()
        let previousSeasonNumber = self.currentSeasonNumber
        self.delegate?.seasonsSequence(self, didEndSeason: self.currentSeasonNumber)
        self.delegate?.season(previousSeasonNumber, didEndAt: screen, with: settings) {
            if self.currentSeasonNumber == .last {
                self.reachedTheEnd = true
                self.delegate?.seasonsSequenceDidEnd(self)
            } else {
                self.seasonIndex += 1
                self.delegate?.seasonsSequence(self, didStartSeason: self.currentSeasonNumber)
                self.delegate?.season(self.currentSeasonNumber, didStartAt: screen, with: settings) {
                    self.delegate?.seasonsSequenceNeedStartTheTimer(self)
                }
            }
        }
    }
    
    /**
     Skip the current season and go the the next. All the delegates methods are called gracefully when skipping
     the season.
     
     - Parameter screen: where the series is being watched.
     - Parameter settings: configuration used to load the series.
     */
    private func skipToTheNext(_ screen: FXScreen, _ settings: FXSettings) {
        #warning("Escrever mensagem de erro")
        guard let series = self.delegate as? FXSeries else { fatalError("fsdfa") }
        let watchData = FXWatchData(what: FXK.WatchData.seasonSkippedToTheNext, where: "")
        series.appendToHistory(watchData)
        
        let previousSeasonNumber = self.currentSeasonNumber
        
        series.killTimeoutTimer()
        self.delegate?.season(previousSeasonNumber, didEndAt: screen, with: settings) {
            if self.currentSeasonNumber == .last {
                self.reachedTheEnd = true
                self.delegate?.seasonsSequenceDidEnd(self)
            } else {
                self.seasonIndex += 1
                self.delegate?.seasonsSequence(self, didStartSeason: self.currentSeasonNumber)
                self.delegate?.season(self.currentSeasonNumber, didStartAt: screen, with: settings) {
                    self.delegate?.seasonsSequenceNeedStartTheTimer(self)
                }
            }
        }
    }
    
    /**
     Skip all seasons and go the the end of the last. All the delegates methods are called gracefully before ending
     the series.
     
     - Parameter screen: where the series is being watched.
     - Parameter settings: configuration used to load the series.
     */
    private func skipToTheEnd(_ screen: FXScreen, _ settings: FXSettings) {
        #warning("Escrever mensagem de erro")
        guard let series = self.delegate as? FXSeries else { fatalError("fsdfa") }
        let watchData = FXWatchData(what: FXK.WatchData.seriesSkippedToTheEnd, where: "")
        series.appendToHistory(watchData)
        
        self.seasonIndex = self.seasons.count - 1
        self.reachedTheEnd = true
        guard let _delegate = self.delegate else {
            fatalError(FXK.ErrorMessage.missingDelegateWhenSkippingSeason)
        }
        
        series.killTimeoutTimer()
        _delegate.season(self.currentSeasonNumber, didEndAt: screen, with: settings) {
            _delegate.seasonsSequenceDidEnd(self)
        }
    }
}
