//
//  MovieDetailViewModel.swift
//  CombineDemo
//
//  Created by João Barbosa on 25/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import Combine
import UIKit

final class MovieDetailViewModel: RouterBindable {

    var router: MovieDetailRouter!
    let moviesAPI: MoviesAPIModel
    let movieId: Int

    private var cancellables: [AnyCancellable] = []

    init(router: MovieDetailRouter, moviesAPI: MoviesAPIModel, movieId: Int) {
        self.router = router
        self.moviesAPI = moviesAPI
        self.movieId = movieId
        self.state = .initial
    }

    enum State {
        case initial
        case loading
        case results(MovieViewData)
        case error(APIError)
    }

    // Just for the sake of using a different approach, unlike the previous scene, here we're going to use a `@Published` property to update the view controller...
    // ... which has the side-effect of obligating this ViewModel to be a class instead.
    @Published var state: State

    func bindPublisher(loadMovie: AnyPublisher<Int, APIError>) {
        let loadingPublisher = loadMovie.map{ _ in State.loading }.eraseToAnyPublisher()

        let resultsPublisher = loadMovie.flatMap({ self.moviesAPI.getMovieDetail(movieId: $0) })
            .map { result -> State in
                return .results(MovieViewData.mapMovieToMovieViewData(movie: result))
        }.eraseToAnyPublisher()

        let mergedPublishers = Publishers.Merge(loadingPublisher, resultsPublisher).removeDuplicates().eraseToAnyPublisher()
        mergedPublishers.sink(receiveCompletion: { completion in
            if case .failure(let apiError) = completion {
                self.state = .error(apiError)
            }
        }, receiveValue: { state in
            self.state = state
            }).store(in: &cancellables)
    }
}

extension MovieDetailViewModel.State: Equatable {
    static func == (lhs: MovieDetailViewModel.State, rhs: MovieDetailViewModel.State) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial): return true
        case (.loading, .loading): return true
        case (.error, .error): return true
        case (.results(let lhsMovie), .results(let rhsMovie)): return lhsMovie == rhsMovie
        default:
            return false
        }
    }
}
