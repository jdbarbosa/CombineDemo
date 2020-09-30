//
//  HomeViewModel.swift
//  CombineDemo
//
//  Created by João Barbosa on 22/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import Combine

final class MovieListViewModel: RouterBindable {

    var router: MovieListRouter!
    let moviesAPI: MoviesAPIModel

    private var cancellables = Set<AnyCancellable>()

    enum State {
        case loading
        case results([MovieViewData])
        case error(APIError)
    }


    init(router: MovieListRouter, moviesAPI: MoviesAPIModel) {
        self.router = router
        self.moviesAPI = moviesAPI
    }


    func transform(input: MovieListInput) -> AnyPublisher<State, APIError> {

        let popularLoading = input.popularMovies.map { _ in State.loading }
            .eraseToAnyPublisher()

        let popularMovies = input.popularMovies.flatMap({ self.moviesAPI.getPopularMovies() })
            .map( { result -> State in
                return .results(result.results.map { MovieViewData.mapMovieToMovieViewData(movie: $0)})
            }).eraseToAnyPublisher()

        let searchLoading = input.search.map { _ in State.loading }
            .eraseToAnyPublisher()

        let search = input.search
            .removeDuplicates()
            .filter({ !$0.isEmpty })
            .flatMap({ self.moviesAPI.search(query: $0) })
            .map( { result -> State in
                return .results(result.results.map { MovieViewData.mapMovieToMovieViewData(movie: $0)})
            }).eraseToAnyPublisher()

        let loadingPublishers = Publishers.Merge(popularLoading, searchLoading).removeDuplicates().eraseToAnyPublisher()
        let resultPublishers = Publishers.Merge(popularMovies, search).removeDuplicates().eraseToAnyPublisher()
        return Publishers.Merge(loadingPublishers, resultPublishers).removeDuplicates().eraseToAnyPublisher()
    }

    func bindSelectionPublisher(selectionPublisher: AnyPublisher<Int, Never>) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        selectionPublisher.sink(receiveValue: { [unowned self] movieId in
            self.moveToMovieDetail(movieId: movieId)
        })
            .store(in: &cancellables)

    }

    private func moveToMovieDetail(movieId: Int) {
        self.router.moveToMovieDetail(movieId: movieId)
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


