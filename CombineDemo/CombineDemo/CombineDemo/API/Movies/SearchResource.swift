//
//  SearchResource.swift
//  CombineDemo
//
//  Created by João Barbosa on 25/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import Foundation

final class SearchResource: APIResource {
    typealias Response = MovieList

    var additionalHeaders: [String : String]?
    var httpBody: Data?
    var httpRequestMethod: HTTPRequestMethod = .get
    var path = "/search/movie"
    var queryItems: [URLQueryItem]? {
        return [URLQueryItem(name: "api_key", value: ApiConstants.apiKey),
                URLQueryItem(name: "language", value: Locale.preferredLanguages[0]),
                URLQueryItem(name: "query", value: query)]
    }

    let query: String

    init(query: String) {
        self.query = query
    }

}
