//
//  FXSeries.swift
//  Storyteller
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 09/05/19.
//  Copyright © 2019 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import Foundation

/**
 Contains all game's logic. It's the entry point for seasons, episodes and chunks of data using the 3W Data Pattern.
 
 You should always call `startWatchNow()` before starting calling other methods in this class. This method will setup
 the instance and call some delegate methods.
 
 It's not necessary to create a chunk of data whenever a season starts or ends. The FXSeries do this automagically.
 */
open class FXSeries: FXScreenDelegate {

    /// How much time a season will wait for an episode to be watched before the entire FXSeries ends.
    private var timeout: TimeInterval {
        guard let settings = self.settings as? FXTimedSettings else { fatalError(FXK.ErrorMessage.unableToCreateTimer) }
        return settings.timeout
    }
    /// The timer used to create timeout effect, if there's one.
    private weak var timer: Timer?
    /// The settings used for various purposes like changing how a game is presented or how many rounds it should have.
    public private(set) var settings: FXSettings?
    
    weak var seriesDelegate: FXScreen?
    /// Used to send the history to the FXSeries presenter whenever the FXSeries ends. You should never set
    /// this method by youself. Instead you should call the presented scene for the current controller or SKView.
    ///
    /// The parameter is all data collected on the game.
    var historyCompletion: ((FXHistory) -> Void)?
    /// Just a grouper used to wapper the logic to iterate over seasons.
    private var seasonSequence: FXSeasonsSequence?
    /// An array with all data collected in the game that will be used later to generate useful data for reserachers.
    private var history = FXHistory()
    /// Control variable used to avoid watching episodes or sending chunks of date after the FXSeries has finished.
    private var seriesStarted = false

    /// Creates an instance of FXSeries. After an instace is created and before watching the first episode,
    /// you should call `startWatchNow()` method.
    public init() {
        if type(of: self) == FXSeries.self {
            fatalError(FXK.ErrorMessage.superclassInitializedCalled)
        }
    }
    
    public func startWatchNow() {
        self.seriesStarted = true
        guard let _screen = self.seriesDelegate else { fatalError(FXK.ErrorMessage.unsettedDelegate("seriesDelegate")) }
        guard let _settings = self.settings else { fatalError(FXK.ErrorMessage.mustHaveSettings) }
        self.seasonSequence?.startFirstSeason(at: _screen, with: _settings)
    }
    
    public func stopWatchNow() {
        self.skipSeason(.toTheEnd)
    }
    
    /// Create the chunk of data to mark when a season starts.
    private func throwSeasonStartedEvent() {
        guard let _seasonSequence = self.seasonSequence else { fatalError(FXK.ErrorMessage.mustHaveSeasonsSequence) }
        let data = FXWatchData(what: FXK.WatchData.seasonStarted, where: "\(_seasonSequence.seasonIndex)")
        self.history.append(data)
    }
    
    /// Create the chunk of data to mark when a season ends.
    private func throwSeasonEndedEvent() {
        guard let _seasonSequence = self.seasonSequence else { fatalError(FXK.ErrorMessage.mustHaveSeasonsSequence) }
        let data = FXWatchData(what: FXK.WatchData.seasonEnded, where: "\(_seasonSequence.seasonIndex)")
        self.history.append(data)
    }
    
    /// Create the chunk of data to mark when a timeout occurs.
    private func throwTimeoutOccuredEvent() {
        guard let _seasonSequence = self.seasonSequence else { fatalError(FXK.ErrorMessage.mustHaveSeasonsSequence) }
        let data = FXWatchData(what: FXK.WatchData.timeoutOccured, where: "\(_seasonSequence.seasonIndex)")
        self.history.append(data)
    }
    
    /// Create the chunk of data to mark when the timeout timer starts.
    private func throwTimeoutTimerStartedEvent() {
        guard let _seasonSequence = self.seasonSequence else { fatalError(FXK.ErrorMessage.mustHaveSeasonsSequence) }
        let data = FXWatchData(what: FXK.WatchData.timeoutTimerStarted, where: "\(_seasonSequence.seasonIndex)")
        self.history.append(data)
    }
    
    /**
     Skip all seasons and go the the end of the last. All the delegates methods are called gracefully before ending
     the series.
     
     - Parameter skipping: how the skipping should be made.
     */
    public func skipSeason(_ skipping: FXSeasonSkipping) {
        guard let _settings = self.settings else { fatalError(FXK.ErrorMessage.mustHaveSettings) }
        guard let _screen = self.seriesDelegate else { fatalError(FXK.ErrorMessage.unsettedDelegate("seriesDelegate")) }
        
        guard let roundIndex = self.seasonSequence?.seasonIndex else { fatalError(FXK.ErrorMessage.mustHaveSeasonsSequence) }
        self.seasonSequence?.skip(skipping, _screen, _settings)
    }

    public func viewer(_ viewer: FXViewer, wannaWatch episode: FXEpisode, at screen: FXScreen, generating data: FXWatchData) {
        guard self.seriesStarted else { fatalError(FXK.ErrorMessage.mustCallStartWatchNow) }
        guard let _seasonSequence = self.seasonSequence else { fatalError(FXK.ErrorMessage.mustHaveSeasonsSequence) }
        self.history.append(data.copyAddingRound(_seasonSequence.seasonIndex))

        guard let _settings = self.settings else { fatalError(FXK.ErrorMessage.mustHaveSettings) }

        self.seasonSequence?.viewer(viewer, wannaWatch: episode, at: screen, with: _settings)
    }

    public func screen(_ screen: FXScreen, didGenerate data: FXWatchData) {
        self.appendToHistory(data)
    }
    
    #warning("Documentar")
    func appendToHistory(_ data: FXWatchData) {
        guard self.seriesStarted else { fatalError(FXK.ErrorMessage.mustCallStartWatchNow) }
        guard let _seasonSequence = self.seasonSequence else { fatalError(FXK.ErrorMessage.mustHaveSeasonsSequence) }
        self.history.append(data.copyAddingRound(_seasonSequence.seasonIndex))
    }

    /**
     This method should be called before a screen be presented. Besides storing the rules internally, it will
     perform some other validation logic like creating a timeout timer if there's one.
     
     - Parameter settings: bucket instance used to store informations about how to present
     the game or how perform validatons.
     */
    func didReceive(_ settings: FXSettings) {
        self.settings = settings

        let _seasons = self.episodes(basedOn: settings)

        guard !_seasons.isEmpty else {
            fatalError(FXK.ErrorMessage.seasonsAreEmpty)
        }

        self.seasonSequence = FXSeasonsSequence(_seasons)
        self.seasonSequence?.delegate = self
    }

    /// Destroys the current timeout timer if there's one.
    func killTimeoutTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }

    /// Creates or resets the current timerout timer if the timer isn't setted to `nil`.
    private func createTimeoutTimerOverridingPrevious() {
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: self.timeout, repeats: false, block: { [weak self] timer in
            guard let this = self else {
                timer.invalidate()
                return
            }
            
            guard let _currentSeasonNumber = this.seasonSequence?.currentSeasonNumber else { fatalError(FXK.ErrorMessage.noCurrentSeason) }
            guard let _settings = this.settings else { fatalError(FXK.ErrorMessage.mustHaveSettings) }
            guard let _screen = this.seriesDelegate else { fatalError(FXK.ErrorMessage.unsettedDelegate("seriesDelegate")) }
            
            this.throwTimeoutOccuredEvent()
            this.seasonTooLong(_currentSeasonNumber, settings: _settings, screen: _screen, skip: { [weak _screen] howToSkip in
                guard let __screen = _screen else { return }
                this.seasonSequence?.skip(howToSkip, __screen, _settings)
            })
        })
    }

    /// This method should be overrided to supplies the seasons for the series.
    /// If this method isn't overrided or returns an empty array of seasons, a
    /// fatal error occures.
    open func episodes(basedOn settings: FXSettings) -> [FXSeason] {
        return []
    }

    /// Called whenever a seasons is taking to long to finishes. That is, the timeout was reached.
    ///
    /// This method will never be called if the timeout time is `nil` or will cause a fatal error
    /// if it is reached and the method isn't overrided.
    /// - Parameter season: season's semantic number
    /// - Parameter settings: current setted settings.
    /// - Parameter screen: where the game is being presented.
    /// - Parameter skipSeriesToTheEnd: you should call this function whenever the timeout happened on your game
    /// must end the entire game generating the data until that moment. Otherwise you should ignore it.
    open func seasonTooLong(_ season: FXNumber, settings: FXSettings, screen: FXScreen, skip: (FXSeasonSkipping) -> Void) {
        fatalError(FXK.ErrorMessage.seasonDidTimeout(self, season))
    }
    
    open func season(_ season: FXNumber, didStartAt screen: FXScreen, with settings: FXSettings, createTimer: @escaping () -> Void) {
        
    }
    
    open func season(_ season: FXNumber, didEndAt screen: FXScreen, with settings: FXSettings, watchNext: @escaping () -> Void) {
        watchNext()
    }

}

extension FXSeries: FXSeasonsSequenceDelegate {
    func seasonsSequenceDidEnd(_ sender: FXSeasonsSequence) {
        guard let _historyCompletion = self.historyCompletion else {
            fatalError(FXK.ErrorMessage.historyCompletionMustBeDefined)
        }
        _historyCompletion(dislocatingOverlappingDates(history: history))
    }

    func seasonsSequence(_ sender: FXSeasonsSequence, didEndSeason index: FXNumber) {
        self.throwSeasonEndedEvent()
    }

    func seasonsSequence(_ sender: FXSeasonsSequence, didStartSeason index: FXNumber) {
        self.throwSeasonStartedEvent()
    }
    
    func seasonsSequenceNeedStartTheTimer(_ sender: FXSeasonsSequence) {
        self.createTimeoutTimerOverridingPrevious()
    }

    /**
     Iterates over all values on this history dislocating overlapping dates
     toward by 0.001 second.

     - Returns: a new history with all dates corrected.
     */

    func dislocatingOverlappingDates(history: FXHistory) -> FXHistory {
        guard history.count >= 2 else { return history }
        var copy = history

        for index in 1..<copy.count {
            if copy[index - 1].when == copy[index].when {
                copy[index] = copy[index].adding(0.001)
            }
        }

        return copy
    }
}

private extension FXWatchData {
    
    /// Helper method used to recreate a chunk of data prefixing it with
    /// the current round.
    func copyAddingRound(_ roundIndex: Int) -> FXWatchData {
        if self.where.isEmpty {
            return FXWatchData(what: self.what, where: "\(roundIndex)")
        }
        return FXWatchData(what: self.what, where: "\(roundIndex)/\(self.where)")
    }
}
