//
//  HomeViewController.swift
//  CombineDemo
//
//  Created by João Barbosa on 22/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import UIKit
import Combine

struct MovieListInput {
    let popularMovies: AnyPublisher<Void, APIError>
    let search: AnyPublisher<String, APIError>
    let selected: AnyPublisher<Int, Never>
}

final class MovieListViewController: UIViewController, ViewModelBindable {
    var viewModel: MovieListViewModel!

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Movies"
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        return searchBar
    }()

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private lazy var dataSource = buildDataSource()

    private var cancellables: [AnyCancellable] = []
    private let mostPopular = PassthroughSubject<Void, APIError>()
    private let search = PassthroughSubject<String, APIError>()
    private let selected = PassthroughSubject<Int, Never>()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.definesPresentationContext = false
        self.setupUI()
        self.bind(to: self.viewModel)
        mostPopular.send(())
    }

    private func setupUI() {
        tableView.register(UINib(nibName: MovieCell.identifier, bundle: nil),
                           forCellReuseIdentifier: MovieCell.identifier)
        tableView.dataSource = dataSource
        tableView.delegate = self

        self.navigationItem.titleView = searchBar
    }

    private func bind(to viewModel: MovieListViewModel) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        let input = MovieListInput(popularMovies: self.mostPopular.eraseToAnyPublisher(),
                                   search: self.search.eraseToAnyPublisher(),
                                   selected: self.selected.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        output.sink(receiveCompletion: { completion in
            if case .failure(let apiError) = completion {
                self.setUI(for: .error(apiError))
            }
        }, receiveValue: { state in
            self.setUI(for: state)
        }).store(in: &cancellables)
    }

    private func setUI(for state: MovieListViewModel.State) {
        switch state {
        case .loading:
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
            self.tableView.isHidden = true
            self.errorLabel.isHidden = true
        case .results(let movies):
            self.tableView.isHidden = false
            self.loadingIndicator.isHidden = true
            self.errorLabel.isHidden = true
            self.updateDataSource(with: movies)
        case .error(let apiError):
            errorLabel.text = "Something went wrong...\n\(apiError.localizedDescription)"
            self.errorLabel.isHidden = false
            self.tableView.isHidden = true
            self.loadingIndicator.isHidden = true
        }
    }
}

extension MovieListViewController {

    enum Section: CaseIterable {
        case movies
    }

    func buildDataSource() -> UITableViewDiffableDataSource<Section, MovieViewData> {
        return UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, movieViewData in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier) as? MovieCell else {
                return UITableViewCell()
            }
            cell.setup(for: movieViewData)
            return cell
        }
    }

    func updateDataSource(with movies: [MovieViewData], animate: Bool = true) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, MovieViewData>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(movies, toSection: .movies)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}

extension MovieListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.mostPopular.send(())
        } else {
            self.search.send(searchText)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.mostPopular.send(())
    }
}

extension MovieListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        self.selected.send(snapshot.itemIdentifiers[indexPath.row].id)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

