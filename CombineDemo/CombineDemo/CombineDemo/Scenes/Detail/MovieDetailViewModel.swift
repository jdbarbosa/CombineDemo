//
//  MovieDetailViewModel.swift
//  CombineDemo
//
//  Created by João Barbosa on 25/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import Combine

struct MovieDetailViewModel: RouterBindable {

    var router: MovieDetailRouter!
    let moviesAPI: MoviesAPI
    let movieId: Int

    enum State {
        case loading
        case results(Movie)
        case error(APIError)
    }

    func transform(loadMovie: AnyPublisher<Int, APIError>) -> AnyPublisher<State, APIError> {
        let resultsPublisher = loadMovie.flatMap({ self.moviesAPI.sendAlamofireRequest(for: MovieDetailsResource(movieId: $0)) })
            .map { result -> State in
                return .results(result)
        }.eraseToAnyPublisher()

        let loadingPublisher = loadMovie.map{ _ in State.loading }.eraseToAnyPublisher()
        return Publishers.Merge(loadingPublisher, resultsPublisher).removeDuplicates().eraseToAnyPublisher()
    }
}

extension MovieDetailViewModel.State: Equatable {
    static func == (lhs: MovieDetailViewModel.State, rhs: MovieDetailViewModel.State) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.error, .error): return true
        case (.results(let lhsMovie), .results(let rhsMovie)): return lhsMovie == rhsMovie
        default:
            return false
        }
    }
}
