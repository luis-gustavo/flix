//
//  FXTimeoutableSeries.swift
//  Flix
//
//  Created by Gustavo Amaral on 23/07/19.
//  Copyright © 2019 Developer Academy | UCB. All rights reserved.
//

import Foundation

/// Used to allow create of a timer for timeout purpose on series' season.
///
/// The conformance with this protocol isn't required, but if you call a method to create
/// a timer and your settings doesn't conform with this protocol, an error will be thrown.
public protocol FXTimedSettings {
    /// How much time the viewer have to finish the season before timing out.
    var timeout: TimeInterval { get set }
}
