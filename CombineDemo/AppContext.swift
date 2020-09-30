//
//  AppContext.swift
//  CombineDemo
//
//  Created by João Barbosa on 22/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import Foundation

struct AppContext {
    let appRouter: AppRouter
    let moviesAPIModel: TheMovieDBModel

    init(appRouter: AppRouter) {
        self.appRouter = appRouter
        self.moviesAPIModel = TheMovieDBModel()
    }
}
