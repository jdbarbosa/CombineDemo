//
//  MovieDetailViewController.swift
//  CombineDemo
//
//  Created by João Barbosa on 25/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import UIKit
import Combine

final class MovieDetailViewController: UIViewController, ViewModelBindable {

    var viewModel: MovieDetailViewModel!

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    private var cancellables: [AnyCancellable] = []
    private let loadMovie = PassthroughSubject<Int, APIError>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind(to: self.viewModel)

        self.loadMovie.send(self.viewModel.movieId)
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
            self.errorLabel.isHidden = true
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
        case .error(let apiError):
            self.errorLabel.isHidden = false
            self.errorLabel.text = apiError.localizedDescription
            self.loadingIndicator.isHidden = true
        case .results(let movie):
            self.loadingIndicator.isHidden = true
            self.errorLabel.isHidden = true
            self.navigationItem.title = movie.title
        }
    }
}
