//
//  EarthquakeListResource.swift
//  CombineDemo
//
//  Created by João Barbosa on 23/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import Foundation

struct UserList: Codable {
    let page: Int
    let total: Int
    let total_pages: Int
    let data: [User]
}

struct User: Codable {
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
    let avatar: String
}

final class UserListResource: APIResource {

    var additionalHeaders: [String : String]?
    var httpBody: Data?
    var httpRequestMethod: HTTPRequestMethod = .get
    var path = "/users"

    var queryItems: [URLQueryItem]? {
        if let page = self.page {
            return [URLQueryItem(name: "page", value: "\(page)")]
        }
        return nil
    }

    typealias Response = UserList

    private let page: Int?

    init(page: Int? = nil) {
        self.page = page
    }
}
