//
//  FXViewer.swift
//  Storyteller
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 09/05/19.
//  Copyright © 2019 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit
import UIKit

/**
 You should use this protocol whenever you something in you screen that generate an event/episode or store some chunk of date
 that will be store on the history.
 */
public protocol FXViewer { }

public extension FXViewer where Self: SKNode {
    /// Where the FXSeries is currently being presented.
    var screen: FXScreen {
        guard let _screen = self.scene as? FXScreen else { fatalError(FXK.ErrorMessage.sceneIsNotFXScreen) }
        return _screen
    }
}

public extension FXViewer where Self: UIView {
    
    /// Tries to find the current controller of `self`. This method can crash in the future if the structure of UIKit changes.
    private var controller: UIViewController {
        guard let currentController = UIViewController.topMostViewController else { fatalError(FXK.ErrorMessage.noTopMostController)}
        
        var currentView: UIView? = self
        while currentView != nil && currentView != currentController.view { currentView = currentView?.superview }
        guard currentView == currentController.view else{ fatalError(FXK.ErrorMessage.viewControllerNotFound(self)) }
        return currentController
    }
    
    /// Where the FXSeries is currently being presented.
    var screen: FXScreen {
        guard let _screen = self.controller as? FXScreen else { fatalError(FXK.ErrorMessage.controllerIsNotFXScreen) }
        return _screen
    }
}

public extension FXViewer where Self: SKNode {
    
    
    /// To where you can send events/episodes and chunks of data to be added on the history.
    var screenDelegate: FXScreenDelegate {
        guard let _delegate = self.screen.screenDelegate else { fatalError(FXK.ErrorMessage.unsettedDelegate("screenDelegate")) }
        return _delegate
    }
    
    /**
     Watch an episode/send an event to the current FXSeries and store some chunk of data.
     
     This is a shortcut method that just call the screen delegate of the current SKNode.
     
     - Parameter episode: What episode should be executed.
     - Parameter data: what should be added on the history to generate informations to the researchers.
     */
    func viewer(wannaWatch episode: FXEpisode, generating data: FXWatchData) {
        self.screenDelegate.viewer(self, wannaWatch: episode, at: self.screen, generating: data)
    }
}

public extension FXViewer where Self: UIView {


    /// To where you can send events/episodes and chunks of data to be added on the history.
    var screenDelegate: FXScreenDelegate {
        guard let _delegate = self.screen.screenDelegate else { fatalError(FXK.ErrorMessage.unsettedDelegate("screenDelegate")) }
        return _delegate
    }

    /**
     Watch an episode/send an event to the current FXSeries and store some chunk fo data.

     This is a shortcut method that just call the screen delegate of the current SKNode.

     - Parameter episode: What episode should be executed.
     - Parameter data: what should be added on the history to generate informations to the researchers.
     */
    func viewer(wannaWatch episode: FXEpisode, generating data: FXWatchData) {
        self.screenDelegate.viewer(self, wannaWatch: episode, at: self.screen, generating: data)
    }
}

private extension UIViewController {
    static var topMostViewController: UIViewController? { return UIApplication.shared.keyWindow?.topmostViewController }
    var topmostViewController: UIViewController? { return presentedViewController?.topmostViewController ?? self }
}

private extension UIWindow { var topmostViewController: UIViewController? { return rootViewController?.topmostViewController } }
