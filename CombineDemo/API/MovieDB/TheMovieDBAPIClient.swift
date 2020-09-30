//
//  MoviesAPI.swift
//  CombineDemo
//
//  Created by João Barbosa on 24/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import Combine
import Foundation

struct TheMovieDBModel: MoviesAPIModel {

    private let client = TheMovieDBAPIClient()

    func getPopularMovies() -> AnyPublisher<MovieList, APIError> {
        return client.sendAlamofireRequest(for: MostPopularResource())
    }

    func search(query: String) -> AnyPublisher<MovieList, APIError> {
        return client.sendAlamofireRequest(for: SearchResource(query: query))
    }

    func getMovieDetail(movieId: Int) -> AnyPublisher<Movie, APIError> {
        return client.sendAlamofireRequest(for: MovieDetailsResource(movieId: movieId))
    }

}

private final class TheMovieDBAPIClient: APIClient {

    var baseUrl = "https://api.themoviedb.org/3"
    var decoder = JSONDecoder()

}

struct ApiConstants {
    static let apiKey = "181af7fcab50e40fabe2d10cc8b90e37"
    static let baseUrl = URL(string: "https://api.themoviedb.org/3")!
    static let originalImageUrl = URL(string: "https://image.tmdb.org/t/p/original")!
    static let smallImageUrl = URL(string: "https://image.tmdb.org/t/p/w154")!
}
