//
//  MostPopularResource.swift
//  CombineDemo
//
//  Created by João Barbosa on 24/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import Foundation

final class MostPopularResource: APIResource {
    typealias Response = MovieList

    var additionalHeaders: [String : String]?
    var httpBody: Data?
    var httpRequestMethod: HTTPRequestMethod = .get
    var path = "/discover/movie"
    var queryItems: [URLQueryItem]? {
        return [URLQueryItem(name: "api_key", value: ApiConstants.apiKey),
                URLQueryItem(name: "language", value: Locale.preferredLanguages[0]),
                URLQueryItem(name: "sort_by", value: "popularity.desc")]
    }

    
}
