//
//  FXSettings.swift
//  Storyteller
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 16/05/19.
//  Copyright © 2019 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import Foundation

/**
 A bucket of properties used to change the behavior and presentation
 of the series before it's presented or even when it's being presented.
 */
public protocol FXSettings {
    
    /// Creates and instance of setting with default values for all properties.
    static var `default`: FXSettings { get }
}
