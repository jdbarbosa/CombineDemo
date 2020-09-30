//
//  MovieListViewModelSpec.swift
//  CombineDemoTests
//
//  Created by João Barbosa on 30/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import Nimble
import Quick
import Combine
import CombineDemo

@testable import CombineDemo

final class MovieListViewModelSpec: QuickSpec {

    typealias State = MovieListViewModel.State

    override func spec() {

        var sceneFactory: SceneFactory!
        var appContext: AppContext!
        var moviesModel: MoviesAPIModel!
        var router: MovieListRouter!

        var popularResults: [Movie]!
        var searchResults: [Movie]!
        var stateStack: [State] = []
        var cancellables: [AnyCancellable] = []

        beforeEach {
            appContext = AppContext.mock()
            sceneFactory = CombineDemoSceneFactory(context: appContext)
            router = MovieListRouter(appRouter: appContext.appRouter,
                                     sceneFactory: sceneFactory)
            let mockAPI = MockMoviesAPIModel()
            moviesModel = mockAPI
            popularResults = mockAPI.popularMovieArray
            searchResults = mockAPI.searchMovieArray
        }
        describe("Movie List View Model") {
            it("Should update the state properly and have the expected set of data") {
                let viewModel = MovieListViewModel(router: router,
                                                   moviesAPI: moviesModel)
                let expectedPopularResultsState = State.results(popularResults.map { MovieViewData.mapMovieToMovieViewData(movie: $0) })
                let expectedSearchResultsState = State.results(searchResults.map { MovieViewData.mapMovieToMovieViewData(movie: $0) })

                let popularMoviesSubject = PassthroughSubject<Void, APIError>()
                let searchMoviesSubject = PassthroughSubject<String, APIError>()

                let input = MovieListInput(popularMovies: popularMoviesSubject.eraseToAnyPublisher(),
                                           search: searchMoviesSubject.eraseToAnyPublisher())

                viewModel.transform(input: input).sink(receiveCompletion: { completion in
                    if case .failure(let apiError) = completion {
                        stateStack.append(State.error(apiError))
                    }
                }, receiveValue: { state in
                    stateStack.append(state)
                }).store(in: &cancellables)

                popularMoviesSubject.send(())
                searchMoviesSubject.send("test")

                let expectedStateArray = [State.loading,
                                          expectedPopularResultsState,
                                          expectedSearchResultsState]
                expect(stateStack).to(equal(expectedStateArray))

            }
        }
    }
}
