//
//  MoviesAPIModel.swift
//  CombineDemo
//
//  Created by João Barbosa on 30/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import Combine

protocol MoviesAPIModel {

    func getPopularMovies() -> AnyPublisher<MovieList, APIError>

    func search(query: String) -> AnyPublisher<MovieList, APIError>

    func getMovieDetail(movieId: Int) -> AnyPublisher<Movie, APIError>
}
