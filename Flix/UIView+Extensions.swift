//
//  UIView+Extensions.swift
//  Storyteller
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 30/05/19.
//  Copyright © 2019 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    /**
     Used to connect a FXSeries instance with a FXScreen instance and present the game
     with the settings.
     
     - Warning: you should use this method to present the screen because it also
     perform some more logic like setting the delegate.
     
     - Parameter series: instance used to handle game logic.
     - Parameter screen: instance used to handle presentation logic.
     - Parameter settings: bucket instance used to store informations about how to present
     the game or how perform validatons.
     - Parameter animated: if the presentation should be animated or not.
     - Parameter completion: called when the game is finished.
     - Parameter history: all data collected in the game.
     - Parameter history: all data collected on the game.
     */
    func watch(_ series: FXSeries, at screen: UIViewController & FXScreen, with settings: FXSettings, animated: Bool = true, completion: @escaping (_ history: FXHistory) -> Void) {
        screen.screenDelegate = series
        series.seriesDelegate = screen
        series.historyCompletion = completion
        series.didReceive(settings)
        present(screen, animated: animated, completion: nil)
    }
}
