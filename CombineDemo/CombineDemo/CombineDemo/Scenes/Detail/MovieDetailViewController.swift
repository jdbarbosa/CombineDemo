//
//  MovieDetailViewController.swift
//  CombineDemo
//
//  Created by João Barbosa on 25/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import UIKit
import Combine
import AlamofireImage

final class MovieDetailViewController: UIViewController, ViewModelBindable {

    var viewModel: MovieDetailViewModel!

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var errorLabel: UILabel!
    private var cancellables: [AnyCancellable] = []
    private let loadMovie = PassthroughSubject<Int, APIError>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind(to: self.viewModel)
        self.setupUI()
        self.loadMovie.send(self.viewModel.movieId)
    }

    private func setupUI() {
        self.titleLabel.font = UIFont(fontStyle: .futuraBold, fontSize: .title)
        self.subtitleLabel.font = UIFont(fontStyle: .proximaNovaRegular, fontSize: .regular)
        self.descriptionLabel.font = UIFont(fontStyle: .proximaNovaRegular, fontSize: .reading)
    }

    private func bind(to viewModel: MovieDetailViewModel) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        let output = viewModel.transform(loadMovie: self.loadMovie.eraseToAnyPublisher())
        output.sink(receiveCompletion: { completion in
            if case .failure(let apiError) = completion {
                self.setUI(for: .error(apiError))
            }
        }, receiveValue: { state in
            self.setUI(for: state)
        }).store(in: &cancellables)
        
    }

    private func setUI(for state: MovieDetailViewModel.State) {
        switch state {
        case .loading:
            self.subtitleLabel.isHidden = true
            self.errorLabel.isHidden = true
            self.titleLabel.isHidden = true
            self.descriptionLabel.isHidden = true
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
        case .error(let apiError):
            self.errorLabel.isHidden = false
            self.errorLabel.text = apiError.localizedDescription
            self.loadingIndicator.isHidden = true
            self.subtitleLabel.isHidden = true
            self.titleLabel.isHidden = true
            self.descriptionLabel.isHidden = true
        case .results(let movie):
            guard let poster = movie.poster else { return }
            let url = ApiConstants.smallImageUrl.appendingPathComponent(poster)
            posterImageView.af.cancelImageRequest()
            posterImageView.af.setImage(withURL: url)
            self.titleLabel.isHidden = false
            self.descriptionLabel.isHidden = false
            self.subtitleLabel.isHidden = false
            self.titleLabel.text = movie.title
            self.descriptionLabel.text = movie.overview
            self.subtitleLabel.text = movie.subtitle
            self.loadingIndicator.isHidden = true
            self.errorLabel.isHidden = true
            self.navigationItem.title = movie.title
        }
    }
}
