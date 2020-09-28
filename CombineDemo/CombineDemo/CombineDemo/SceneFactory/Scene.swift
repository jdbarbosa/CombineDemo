//
//  Scene.swift
//  CombineDemo
//
//  Created by João Barbosa on 22/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import UIKit

protocol Scene {
    func make(factory: SceneFactory, context: AppContext) -> UIViewController
}

/// Implementing this protocol gives you the ability to unpack a view controller the storyboard and have a
/// view model instance attached to them. All you have to implement is `viewModel` and the rest has a default
/// implementation.
protocol ViewModelScene: Scene {
    associatedtype ViewControllerType where ViewControllerType: UIViewController, ViewControllerType: ViewModelBindable, ViewControllerType.ViewModelType: RouterBindable

    typealias ViewModelType = ViewControllerType.ViewModelType
    typealias RouterType = ViewModelType.RouterType
    typealias ViewModelFactory = (SceneFactory, AppContext) -> ViewModelType

    /// Implement this to use a custom storyboard to load the scene. Default is to find a storyboard with this type's name.
    var storyboardName: String { get }

    var storyboard: UIStoryboard { get }

    var viewModel: ViewModelFactory { get }

}

extension ViewModelScene {

    /// ViewModelScene scenes can override this to provide their own storyboards from the resource bundle
    var storyboardName: String { return String(describing: type(of: self)) }

    /// Loads storyboard from default bundle
    var storyboard: UIStoryboard {
        return UIStoryboard(name: self.storyboardName, bundle: nil)
    }

    /// Get the storyboard identifier from the given type - the default behaviour is just to use the class name.
    private var viewControllerIdentifier: String {
        return String(describing: ViewControllerType.self)
    }

}

extension ViewModelScene {

    /// Default method to create a UIViewController, if further configuration is needed, this can be overriden on the respective ViewModelScene implementation
    func make(factory: SceneFactory, context: AppContext) -> UIViewController {
        return self.createViewController(factory: factory, context: context)
    }

    private func createViewController(factory: SceneFactory, context: AppContext) -> ViewControllerType {
        return self.createViewModelBindalbleController(for: self.viewModel(factory, context),
                                         identifier: self.viewControllerIdentifier)
    }

    private func createViewModelBindalbleController<T>(for viewModel: T.ViewModelType, identifier: String) -> T where T: UIViewController, T: ViewModelBindable {

        let viewController = self.storyboard.instantiateViewController(withIdentifier: identifier)
        guard var viewModelBindableController = viewController as? T else {
            fatalError("Instantiated view controller of invalid type, expceted \(T.self), found \(type(of: viewController))")
        }
        viewModelBindableController.viewModel = viewModel
        return viewModelBindableController

    }
}

struct MovieListScene: ViewModelScene {

    typealias ViewControllerType = MovieListViewController

    var viewModel: ViewModelFactory = { factory, context in
        MovieListViewModel(router: MovieListRouter(appRouter: context.appRouter, sceneFactory: factory),
                           moviesAPI: context.moviesAPI)
    }
}

struct MovieDetailScene: ViewModelScene {

    typealias ViewControllerType = MovieDetailViewController

    var viewModel: ViewModelFactory

    init(movieId: Int) {
        self.viewModel = { factory, context in
            MovieDetailViewModel(router: MovieDetailRouter(appRouter: context.appRouter,
                                                           sceneFactory: factory),
                                 moviesAPI: context.moviesAPI,
                                 movieId: movieId)
        }
    }
}
