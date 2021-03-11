//
//  SKView+Extensions.swift
//  Storyteller
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 16/05/19.
//  Copyright © 2019 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit

public extension SKView {
    
    /**
     Used to connect a FXSeries instance with a FXScreen instance and present the game
     with the settings.
     
     - Warning: you should use this method to present the screen because it also
     perform some more logic like setting the delegate.
     
     - Parameter series: instance used to handle game logic.
     - Parameter screen: instance used to handle presentation logic.
     - Parameter settings: bucket instance used to store informations about how to present
     the game or how perform validatons.
     - Parameter transition: how the game should be animated when being presented.
     - Parameter completion: called when the game is finished.
     - Parameter history: all data collected in the game.
     */
    func watch(_ series: FXSeries, at screen: SKScene & FXScreen, with settings: FXSettings, transition: SKTransition? = nil, completion: @escaping (_ history: FXHistory) -> Void) {
        screen.screenDelegate = series
        series.seriesDelegate = screen
        series.historyCompletion = completion
        series.didReceive(settings)
        if let _transition = transition {
            presentScene(screen, transition: _transition)
        } else {
            presentScene(screen)
        }
    }
}
