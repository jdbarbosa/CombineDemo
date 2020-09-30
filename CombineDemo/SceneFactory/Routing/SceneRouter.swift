//
//  SceneRouter.swift
//  CombineDemo
//
//  Created by João Barbosa on 23/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import UIKit

/// Enum that defines the types of transitions available for each scene
///
/// - root: Becomes the root of the navigation, replacing the current window
/// - push: Pushes the scene into an existing navigation controller
/// - modal: Show the scene as a modal
enum SceneTransitionType {
    case root(animated: Bool)
    case push
    case modal(animated: Bool)
}

/// Protocol used by objects that are responsible of handling scene transitions
protocol SceneRouter {

    /// Transition to a scene, specifying the type of transition to use
    func transition(to scene: UIViewController, type: SceneTransitionType)

    /// Call this to transition back one scene in a navigation controller
    ///
    /// - parameter animated: Should the pop be animated
    /// - parameter completion: Called when the animation is finished, if it was a modal. Thanks, iOS.
    func pop(animated: Bool, completion: (() -> Void)?)

    /// Reference for AppRouter that holds the window and the ViewController currently being presented
    var appRouter: AppRouter { get }

}

extension SceneRouter {

    /// Method that transitions into a new Scene
    ///
    /// - Parameters:
    ///   - scene: The Scene we want to go to
    ///   - type: The type of the transition to use
    public func transition(to viewController: UIViewController, type: SceneTransitionType = .push) {
        switch type {
        case .root(let animated):
            let instructions = {
                self.appRouter.setInitialScene(viewController: viewController)
            }
            if animated {
                UIView.transition(from: self.appRouter.currentViewController!.view!,
                                  to: viewController.view,
                                  duration: 1.25,
                                  options: [.layoutSubviews, .transitionCrossDissolve]) { _ in
                                    instructions()
                }
            } else {
                instructions()
            }
        case .push:
            guard let navigationController = self.appRouter.currentViewController.navigationController else {
                fatalError("Can't push a view controller without a current navigation controller")
            }
            navigationController.pushViewController(viewController, animated: true)
        case .modal(let animated):
            // Embedding view controller in a navigation controller by default
            let toPresent = UINavigationController(rootViewController: viewController)
            toPresent.transitioningDelegate = viewController.transitioningDelegate
            toPresent.modalPresentationStyle = viewController.modalPresentationStyle

            self.appRouter.currentViewController.present(toPresent, animated: animated)
        }
    }

    /// Method that returns to the previous view controller either by dismissing the modal
    /// or popping from the navigation controller
    ///
    /// - Parameter animated: True if we should animate the transition
    public func pop(animated: Bool, completion: (() -> Void)?) {
        //We can have a navigation controller embedded in a modal view controller, so let's check for that first
        if let navigationController = self.appRouter.currentViewController.navigationController,
            self.appRouter.currentViewController != navigationController.viewControllers.first {
            navigationController.popViewController(animated: animated)
        } else if let presenter = self.appRouter.currentViewController.presentingViewController {
            // dismiss a modal controller
            presenter.dismiss(animated: animated, completion: completion)
        } else {
            fatalError("Not a modal, no navigation controller: can't navigate back from \(String(describing: appRouter.currentViewController))")
        }
    }

}

