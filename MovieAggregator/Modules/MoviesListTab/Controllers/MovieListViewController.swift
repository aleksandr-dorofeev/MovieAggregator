// MovieListViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Screen with movies.
final class MovieListViewController: UIViewController {
    // MARK: - Private Constants.

    private enum Constants {
        static let placeholderForSearchControllerName = "Поиск..."
        static let popularButtonText = "Популярное"
        static let topRatingButtonText = "Топ"
        static let upComingButtonText = "Скоро"
        static let topRatedCategoryUrlText = "top_rated?"
        static let popularCategoryUrlText = "popular?"
        static let upcomingCategoryUrlText = "upcoming?"
    }

    // MARK: - Private enums.

    private enum CurrentCategoryOfMovies {
        case popular
        case topRating
        case upComing
    }

    // MARK: - Private visual components.

    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = UIColor(named: Colors.backgroundColor)
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var moviesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.backgroundColor = UIColor(named: Colors.backgroundColor)
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(
            MovieCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieCollectionViewCell.Identifier.movieCellID
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var popularButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.popularButtonText, for: .normal)
        button.backgroundColor = UIColor(named: Colors.buttonColor)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(popularAction), for: .touchUpInside)
        return button
    }()

    private lazy var topRatedButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.topRatingButtonText, for: .normal)
        button.backgroundColor = UIColor(named: Colors.buttonColor)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(topRatingAction), for: .touchUpInside)
        return button
    }()

    private lazy var upComingButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.upComingButtonText, for: .normal)
        button.backgroundColor = UIColor(named: Colors.buttonColor)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(upComingAction), for: .touchUpInside)
        return button
    }()

    // MARK: - Private properties.

    private let searchController = UISearchController(searchResultsController: nil)
    private var movies: [Movie]? = []
    private var page = 1
    private let countCellForStartingPagination = 6
    private var hasNextPage = true
    private var fetchingMore = false
    private var currentCategoryMovies: CurrentCategoryOfMovies = .popular

    // MARK: - Life cycle.

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData(categoryOfMovies: Constants.popularCategoryUrlText)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupConstraintsForCollectionView()
        setupConstraintsForStackView()
    }

    // MARK: - Private methods.

    private func setupUI() {
        addSubviews()
        createSearchController()
    }

    private func fetchData(categoryOfMovies: String) {
        fetchingMore = true
        NetworkService.shared.getMovies(categoryOfMovies: categoryOfMovies, page: page) { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case let .success(movies):
                    guard let secureFetchMovies = movies?.results else { return }
                    guard !secureFetchMovies.isEmpty else {
                        self.hasNextPage = false
                        self.fetchingMore = false
                        self.reloadMoviesList()
                        return
                    }
                    self.movies?.append(contentsOf: secureFetchMovies)
                    self.reloadMoviesList()
                case let .failure(error):
                    self.showError(error: error)
                }
                self.fetchingMore = false
            }
        }
    }

    private func loadMoreMovies() {
        guard !fetchingMore, hasNextPage else { return }
        page += 1
        DispatchQueue.main.async {
            self.fetchData(categoryOfMovies: Constants.popularCategoryUrlText)
        }
    }

    private func reloadMoviesList() {
        moviesCollectionView.reloadData()
    }

    private func showError(error: Error) {
        print(error.localizedDescription)
    }

    private func addSubviews() {
        view.addSubview(moviesCollectionView)
        view.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(popularButton)
        horizontalStackView.addArrangedSubview(topRatedButton)
        horizontalStackView.addArrangedSubview(upComingButton)
    }

    private func setupConstraintsForCollectionView() {
        NSLayoutConstraint.activate(
            [
                moviesCollectionView.topAnchor
                    .constraint(equalTo: horizontalStackView.bottomAnchor),
                moviesCollectionView.leadingAnchor
                    .constraint(equalTo: view.leadingAnchor),
                moviesCollectionView.trailingAnchor
                    .constraint(equalTo: view.trailingAnchor),
                moviesCollectionView.bottomAnchor
                    .constraint(equalTo: view.bottomAnchor),
            ]
        )
    }

    private func setupConstraintsForStackView() {
        NSLayoutConstraint.activate(
            [
                horizontalStackView.topAnchor
                    .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                horizontalStackView.leadingAnchor
                    .constraint(equalTo: view.leadingAnchor, constant: 10),
                horizontalStackView.trailingAnchor
                    .constraint(equalTo: view.trailingAnchor, constant: -10),
            ]
        )
    }

    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let cellWidthConstant: CGFloat = UIScreen.main.bounds.width / 2.2
        let cellHeightConstant: CGFloat = UIScreen.main.bounds.height / 3
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.itemSize = CGSize(width: cellWidthConstant, height: cellHeightConstant)
        return layout
    }

    // MARK: - Private actions.

    @objc private func popularAction() {
        movies?.removeAll()
        page = 1
        currentCategoryMovies = .popular
        fetchData(categoryOfMovies: Constants.popularCategoryUrlText)
    }

    @objc private func topRatingAction() {
        movies?.removeAll()
        page = 1
        currentCategoryMovies = .topRating
        fetchData(categoryOfMovies: Constants.topRatedCategoryUrlText)
    }

    @objc private func upComingAction() {
        movies?.removeAll()
        page = 1
        currentCategoryMovies = .upComing
        fetchData(categoryOfMovies: Constants.upcomingCategoryUrlText)
    }
}

extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for _: UISearchController) {}

    private func createSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.placeholderForSearchControllerName
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = false
    }
}

extension MovieListViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        movies?.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MovieCollectionViewCell.Identifier.movieCellID,
                for: indexPath
            ) as? MovieCollectionViewCell,
            let movie = movies?[indexPath.row]
        else { return UICollectionViewCell() }
        cell.configureMoviesCell(movie: movie)
        return cell
    }

    func collectionView(
        _: UICollectionView,
        willDisplay _: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard let movies = movies else { return }
        if indexPath.row == movies.count - countCellForStartingPagination {
            loadMoreMovies()
        }
    }
}

extension MovieListViewController: UICollectionViewDelegate {}
