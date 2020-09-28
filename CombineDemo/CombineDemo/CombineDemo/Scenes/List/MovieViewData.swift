//
//  MovieViewData.swift
//  CombineDemo
//
//  Created by João Barbosa on 24/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import Foundation

import UIKit.UIImage
import Combine

/// Struct that represents the Movie object but already prepared to be displayed
struct MovieViewData {
    let id: Int
    let title: String
    let subtitle: String
    let overview: String
    let poster: String?
    let rating: String


    init(id: Int, title: String, subtitle: String, overview: String, poster: String?, rating: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.overview = overview
        self.poster = poster
        self.rating = rating
    }
}

extension MovieViewData: Hashable {
    static func == (lhs: MovieViewData, rhs: MovieViewData) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
