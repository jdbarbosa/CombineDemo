//
//  SceneFactory.swift
//  CombineDemo
//
//  Created by João Barbosa on 22/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import UIKit

/// A SceneFactory is just a holder of the SceneFactoryContext and a proxy through a Scene and its worker that will create it.
protocol SceneFactory {

    /// Given a scene, attempt to create a UIViewController from it. The factory will use the last added worker for that
    /// identifier.
    func create<T: Scene>(_ scene: T) -> UIViewController
}

final class CombineDemoSceneFactory: SceneFactory {

    private let context: AppContext

    init(context: AppContext) {
        self.context = context
    }

    func create<T>(_ scene: T) -> UIViewController where T : Scene {
        return self.buildViewController(for: scene)
    }

    private func buildViewController<T: Scene>(for scene: T) -> T.ViewControllerType {
        return self.buildViewModelBindalbleController(for: self.buildViewModel(for: scene),
                                                       with: scene.viewControllerIdentifier,
                                                       from: scene.storyboard)
    }

    private func buildViewModel<T: Scene>(for scene: T) -> T.ViewModelType {
        return scene.viewModel(scene.router(self, self.context), self.context)
    }

    private func buildViewModelBindalbleController<T>(for viewModel: T.ViewModelType, with identifier: String, from storyboard: UIStoryboard) -> T where T: UIViewController, T: ViewModelBindable {

        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        guard var viewModelBindableController = viewController as? T else {
            fatalError("Instantiated view controller of invalid type, expceted \(T.self), found \(type(of: viewController))")
        }
        viewModelBindableController.viewModel = viewModel
        return viewModelBindableController

    }
}
