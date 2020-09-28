//
//  HomeViewModel.swift
//  CombineDemo
//
//  Created by João Barbosa on 22/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import UIKit
import Combine

final class MovieListViewModel: RouterBindable {

    var router: MovieListRouter!
    let moviesAPI: MoviesAPI

    private var disposables = Set<AnyCancellable>()

    enum State {
        case loading
        case results([MovieViewData])
        case error(APIError)
    }


    init(router: MovieListRouter, moviesAPI: MoviesAPI) {
        self.router = router
        self.moviesAPI = moviesAPI
    }


    func transform(input: MovieListInput) -> AnyPublisher<State, APIError> {
        disposables.forEach { $0.cancel() }
        disposables.removeAll()
        input.selected.sink(receiveValue: { [unowned self] movieId in
            self.moveToMovieDetail(movieId: movieId)
        })
            .store(in: &disposables)

        let popularLoading = input.popularMovies.map { _ in State.loading }
            .eraseToAnyPublisher()

        let popularMovies = input.popularMovies.flatMap({ self.moviesAPI.sendAlamofireRequest(for: MostPopularResource()) })
            .map( { result -> State in
                return .results(result.results.map { self.mapMovieToMovieViewData(movie: $0)})
            }).eraseToAnyPublisher()

        let searchLoading = input.search.map { _ in State.loading }
            .eraseToAnyPublisher()

        let search = input.search
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter({ !$0.isEmpty })
            .flatMap({ self.moviesAPI.sendAlamofireRequest(for: SearchResource(query: $0)) })
            .map( { result -> State in
                return .results(result.results.map { self.mapMovieToMovieViewData(movie: $0)})
            }).eraseToAnyPublisher()

        let loadingPublishers = Publishers.Merge(popularLoading, searchLoading).removeDuplicates().eraseToAnyPublisher()
        let resultPublishers = Publishers.Merge(popularMovies, search).removeDuplicates().eraseToAnyPublisher()
        return Publishers.Merge(loadingPublishers, resultPublishers).removeDuplicates().eraseToAnyPublisher()
    }

    private func moveToMovieDetail(movieId: Int) {
        self.router.moveToMovieDetail(movieId: movieId)
    }

    private func mapMovieToMovieViewData(movie: Movie) -> MovieViewData {
        return MovieViewData(id: movie.id,
                             title: movie.title,
                             subtitle: movie.subtitle,
                             overview: movie.overview,
                             poster: movie.poster_path,
                             rating: String(format: "%.2f", movie.vote_average))
    }

}

extension MovieListViewModel.State: Equatable {
    static func == (lhs: MovieListViewModel.State, rhs: MovieListViewModel.State) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.results(let lhsMovies), .results(let rhsMovies)): return lhsMovies == rhsMovies
        case (.error, .error): return true
        default:
            return false
        }
    }
}


