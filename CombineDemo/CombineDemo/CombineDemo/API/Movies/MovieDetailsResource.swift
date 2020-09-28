//
//  MovieDetailsResource.swift
//  CombineDemo
//
//  Created by João Barbosa on 25/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import Foundation

final class MovieDetailsResource: APIResource {

    typealias Response = Movie

    let additionalHeaders: [String : String]? = nil
    let httpBody: Data? = nil
    let httpRequestMethod: HTTPRequestMethod = .get
    let path: String
        var queryItems: [URLQueryItem]? {
        return [URLQueryItem(name: "api_key", value: ApiConstants.apiKey),
                URLQueryItem(name: "language", value: Locale.preferredLanguages[0])]
    }

    init(movieId: Int) {
        self.path = "/movie/\(movieId)"
    }

}
