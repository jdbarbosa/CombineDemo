//
//  Scene.swift
//  CombineDemo
//
//  Created by João Barbosa on 22/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import UIKit

/// A Scene is defined by having a View Controller, a view model and a router to handle its transitions.
/// Implementing this protocol gives you the ability to unpack a view controller from the storyboard and have a
/// view model instance attached to it. All you have to implement is `viewModel` and `router` and the rest has a default
/// implementation.
protocol Scene {
    associatedtype ViewControllerType where ViewControllerType: UIViewController, ViewControllerType: ViewModelBindable, ViewControllerType.ViewModelType: RouterBindable

    typealias ViewModelType = ViewControllerType.ViewModelType
    typealias RouterType = ViewModelType.RouterType
    typealias RouterFactory = (SceneFactory, AppContext) -> RouterType
    typealias ViewModelFactory = (RouterType, AppContext) -> ViewModelType


    /// Implement this to use a custom storyboard to load the scene. Default is to find a storyboard with this type's name.
    var storyboardName: String { get }

    var storyboard: UIStoryboard { get }

    /// Both the viewModel and the router need to be explicitly implemented by the scene.
    var viewModel: ViewModelFactory { get }

    var router: RouterFactory { get }

}

extension Scene {

    /// ViewModelScene scenes can override this to provide their own storyboards from the resource bundle
    var storyboardName: String { return String(describing: type(of: self)) }

    /// Loads storyboard from default bundle
    var storyboard: UIStoryboard {
        return UIStoryboard(name: self.storyboardName, bundle: nil)
    }

    /// Get the storyboard identifier from the given type - the default behaviour is just to use the class name.
    var viewControllerIdentifier: String {
        return String(describing: ViewControllerType.self)
    }

}

struct MovieListScene: Scene {

    typealias ViewControllerType = MovieListViewController

    var router: RouterFactory = { factory, context in
        MovieListRouter(appRouter: context.appRouter, sceneFactory: factory)
    }

    var viewModel: ViewModelFactory = { router, context in
        MovieListViewModel(router: router,
                           moviesAPI: context.moviesAPIModel)
    }
}

struct MovieDetailScene: Scene {

    typealias ViewControllerType = MovieDetailViewController

    var viewModel: ViewModelFactory

    var router: RouterFactory = { factory, context in
        MovieDetailRouter(appRouter: context.appRouter, sceneFactory: factory)
    }

    init(movieId: Int) {
        self.viewModel = { router, context in
            MovieDetailViewModel(router: router,
                                 moviesAPI: context.moviesAPIModel,
                                 movieId: movieId)
        }
    }
}
