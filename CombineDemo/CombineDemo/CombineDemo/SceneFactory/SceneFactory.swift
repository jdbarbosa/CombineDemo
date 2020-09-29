//
//  SceneFactory.swift
//  CombineDemo
//
//  Created by João Barbosa on 22/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import UIKit

/// The SceneFactory holds an AppContext and has the responsibility to create ViewControllers and bind them with the respective view models.
protocol SceneFactory {

    /// Given a scene, create a UIViewController from it
    func create<T: Scene>(_ scene: T) -> UIViewController
}

final class CombineDemoSceneFactory: SceneFactory {

    private let context: AppContext

    init(context: AppContext) {
        self.context = context
    }

    /// Return a UIViewController for the Scene
    func create<T>(_ scene: T) -> UIViewController where T : Scene {
        return self.buildViewController(for: scene)
    }

    /// Return the typed ViewController
    private func buildViewController<T: Scene>(for scene: T) -> T.ViewControllerType {
        return self.buildViewModelBindalbleController(for: self.buildViewModel(for: scene),
                                                       with: scene.viewControllerIdentifier,
                                                       from: scene.storyboard)
    }

    /// Build the scene's view model
    private func buildViewModel<T: Scene>(for scene: T) -> T.ViewModelType {
        return scene.viewModel(scene.router(self, self.context), self.context)
    }

    /// Build the scene's view controller from the scene's identifier and storyboard, and assign it with the respective view model
    private func buildViewModelBindalbleController<T>(for viewModel: T.ViewModelType, with identifier: String, from storyboard: UIStoryboard) -> T where T: UIViewController, T: ViewModelBindable {

        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        guard var viewModelBindableController = viewController as? T else {
            fatalError("Instantiated view controller of invalid type, expceted \(T.self), found \(type(of: viewController))")
        }
        viewModelBindableController.viewModel = viewModel
        return viewModelBindableController

    }
}
