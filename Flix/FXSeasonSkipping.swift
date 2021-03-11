//
//  FXSeasonSkipping.swift
//  Flix
//
//  Created by Gustavo Amaral on 16/07/19.
//  Copyright © 2019 Developer Academy | UCB. All rights reserved.
//

import Foundation

/// An type that describes how the current season should be skipped when handling the natural
/// flow of seasons presenting.
public enum FXSeasonSkipping {
    /// Tells the FXSeries that it should to the the end of the last season.
    case toTheEnd
    /// Tells the FXSeries that it should to the next season, "aborting"
    /// the current season.
    case toTheNext
    #warning("Documentar")
    case by(amount: Int)
}
