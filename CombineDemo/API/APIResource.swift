//
//  APIResource.swift
//  CombineDemo
//
//  Created by João Barbosa on 23/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import Foundation

public protocol APIResource {
    /// The associated response type to use when decoding the response from the API.
    associatedtype Response: Codable

    /// A dictionary of additional headers to send with the request.
    var additionalHeaders: [String: String]? { get }

    /// The data sent as the message body of the request.
    var httpBody: Data? { get }

    /// The HTTP request method.
    var httpRequestMethod: HTTPRequestMethod { get }

    /// The path subcomponent appended to the base URL.
    var path: String { get }

    /// An array of query items for the URL, in the order in which they appear.
    var queryItems: [URLQueryItem]? { get }
}

extension APIResource {

    func buildRequest(withBaseUrl baseUrl: URL?) -> URLRequest? {
        guard let url = buildUrl(withBaseUrl: baseUrl) else {
            NSLog("failed to build request for resource: \(String(describing: self))")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpRequestMethod.rawValue
        request.httpBody = httpBody

        additionalHeaders?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }

    func buildUrl(withBaseUrl baseUrl: URL?) -> URL? {
        guard
            let baseUrl = baseUrl,
            var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        else {
            NSLog("failed to build url for resource: \(String(describing: self))")
            return nil
        }
        components.path = baseUrl.path.appending(path)
        components.queryItems = queryItems
        return components.url
    }
}

public enum HTTPRequestMethod: String {
    case delete, get, patch, post, put
}
