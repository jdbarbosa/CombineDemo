//
//  HomeRouter.swift
//  CombineDemo
//
//  Created by João Barbosa on 23/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import Foundation

struct MovieListRouter: SceneRouter {
    let appRouter: AppRouter
    let sceneFactory: SceneFactory

    func moveToMovieDetail(movieId: Int) {
        let movieDetailScene = MovieDetailScene(movieId: movieId)
        self.transition(to: self.sceneFactory.create(movieDetailScene))
    }

}
