//
//  APIClient.swift
//  CombineDemo
//
//  Created by João Barbosa on 23/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import Foundation
import Combine
import Alamofire

protocol APIClient {

    /// The base URL
    var baseUrl: String { get }

    /// The decoder to use for JSON decoding.
    var decoder: JSONDecoder { get }

    /// Starts a URLSessionDataTask using the request for the corresponding APIResource.
    ///
    /// - Parameters:
    ///   - resource: APIResource defining some remote resource.
    /// - Returns: AnyPublisher for the corresponding resource, or nil.

    func sendRequest<T: APIResource>(for resource: T) -> AnyPublisher<T.Response, APIError>

    func sendAlamofireRequest<T: APIResource>(for resource: T) -> AnyPublisher<T.Response, APIError>
}

extension APIClient {

    func sendRequest<T: APIResource>(for resource: T) -> AnyPublisher<T.Response, APIError> {

        guard let request = resource.buildRequest(withBaseUrl: URL(string: self.baseUrl)) else {
            print("Bad url")
            return Fail(error: APIError.client).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { _ in APIError.network }
            .map { $0.data }
            .decode(type: T.Response.self, decoder: JSONDecoder())
            .mapError {_ in APIError.decoding }
            .eraseToAnyPublisher()
    }

    func sendAlamofireRequest<T: APIResource>(for resource: T) -> AnyPublisher<T.Response, APIError> {
        guard let request = resource.buildRequest(withBaseUrl: URL(string: self.baseUrl)) else {
            print("Bad url")
            return Fail(error: APIError.client).eraseToAnyPublisher()
        }

        return AF.request(request).publishData()
            .mapError { _ in APIError.network }
            .compactMap { $0.data }
            .decode(type: T.Response.self, decoder: JSONDecoder())
            .mapError { _ in APIError.decoding }
            .eraseToAnyPublisher()
    }
}


