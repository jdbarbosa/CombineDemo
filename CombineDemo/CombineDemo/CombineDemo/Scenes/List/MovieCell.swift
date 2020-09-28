//
//  MovieCell.swift
//  CombineDemo
//
//  Created by João Barbosa on 24/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import UIKit
import Combine
import AlamofireImage

final class MovieCell: UITableViewCell {

    static let identifier = "MovieCell"

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!

    private var imageCancellable: AnyCancellable?

    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.af.cancelImageRequest()
    }


    func setup(for movie: MovieViewData) {

        movieTitleLabel.text = movie.title
        movieGenreLabel.text = movie.subtitle

        guard let poster = movie.poster else { return }
        let url = ApiConstants.smallImageUrl.appendingPathComponent(poster)

        // TODO: would be better if we could use something more Combine-y here as well, wouldn't it?
        movieImageView.af.cancelImageRequest()
        movieImageView.af.setImage(withURL: url)
    }

}

enum ImageSize {
    case small
    case original
    var url: URL {
        switch self {
        case .small: return ApiConstants.smallImageUrl
        case .original: return ApiConstants.originalImageUrl
        }
    }
}
