//
//  MovieModel.swift
//  CombineDemo
//
//  Created by João Barbosa on 24/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let title: String
    let overview: String
    let poster_path: String?
    let vote_average: Float
    let release_date: String?
    let genre_ids: [GenreId]?
    let genres: [Genre]?

}

struct MovieList: Codable {
    let results: [Movie]
}

extension Movie: Hashable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


struct Genre: Codable {
    let id: GenreId
    let name: String
}

enum GenreId: Int, CustomStringConvertible, Codable, Hashable {
    case action = 28
    case adventure = 12
    case animation = 16
    case comedy = 35
    case crime = 80
    case documentary = 99
    case drama = 18
    case family = 10751
    case fantasy = 14
    case history = 36
    case horror = 27
    case music = 10402
    case mystery = 9648
    case romance = 10749
    case scienceFiction = 878
    case tvMovie = 10770
    case thriller = 53
    case war = 10752
    case western = 37

    var description: String {
        switch self {
            case .action: return NSLocalizedString("Action", comment: "Action")
            case .adventure: return NSLocalizedString("Adventure", comment: "Adventure")
            case .animation: return NSLocalizedString("Animation", comment: "Animation")
            case .comedy: return NSLocalizedString("Comedy", comment: "Comedy")
            case .crime: return NSLocalizedString("Crime", comment: "Crime")
            case .documentary: return NSLocalizedString("Documentary", comment: "Documentary")
            case .drama: return NSLocalizedString("Drama", comment: "Drama")
            case .family: return NSLocalizedString("Family", comment: "Family")
            case .fantasy: return NSLocalizedString("Fantasy", comment: "Fantasy")
            case .history: return NSLocalizedString("History", comment: "History")
            case .horror: return NSLocalizedString("Horror", comment: "Horror")
            case .music: return NSLocalizedString("Music", comment: "Music")
            case .mystery: return NSLocalizedString("Mystery", comment: "Mystery")
            case .romance: return NSLocalizedString("Romance", comment: "Romance")
            case .scienceFiction: return NSLocalizedString("Science Fiction", comment: "Science Fiction")
            case .tvMovie: return NSLocalizedString("TV Movie", comment: "TV Movie")
            case .thriller: return NSLocalizedString("Thriller", comment: "Thriller")
            case .war: return NSLocalizedString("War", comment: "War")
            case .western: return NSLocalizedString("Western", comment: "Western")
        }
    }
}

extension Movie {
    var genreNames: [String] {
        if let genreIds = genre_ids {
            return genreIds.map { $0.description }
        }
        if let genres = genres {
            return genres.map { $0.name }
        }
        return []
    }
    var subtitle: String {
        let genresDescription = genreNames.joined(separator: ", ")
        return "\(releaseYear) | \(genresDescription)"
    }
    var releaseYear: Int {
        let date = release_date.flatMap { Movie.dateFormatter.date(from: $0) } ?? Date()
        return Calendar.current.component(.year, from: date)
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
