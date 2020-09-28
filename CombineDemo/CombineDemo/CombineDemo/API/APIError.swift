//
//  APIError.swift
//  CombineDemo
//
//  Created by João Barbosa on 23/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import Foundation

enum APIError: Error {
    /// For client side errors, such as failing to build a request to the server.
    case client

    /// For decoding errors, such as failing to decode a response from the server.
    case decoding

    /// For network errors, such as 404 not found etc.
    case network

    /// For when the client receives an unexpected response from the server.
    case unrecognizedFormat

    /// For when the network is unreachable.
    case unreachable

    /// For when login credentials are no longer valid, or unexisting
    case notAuthenticated

    /// Critical error for when the dependencies to create the request are inconsistent
    case inconsistentData
}

extension APIError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .client:
            return "Client error."
        case .decoding:
            return "Decoding error."
        case .network:
            return "Network error."
        case .unrecognizedFormat:
            return "Unrecognized Format."
        case .unreachable:
            return "Unreachable."
        case .notAuthenticated:
            return "Not Authenticated."
        case .inconsistentData:
            return "Inconsistent Data."
        }
    }
}
