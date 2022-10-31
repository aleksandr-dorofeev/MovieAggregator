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
    }

    private enum UrlComponent {
        static let movieBaseUrlText = "https://api.themoviedb.org/3/"
        static let moviePath = "movie/"
        static let topRatedCategoryUrlText = "top_rated?"
        static let popularCategoryUrlText = "popular?"
        static let upcomingCategoryUrlText = "upcoming?"
    }

    private enum Identifier {
        static let movieCellID = "MovieCollectionViewCell"
    }

    // MARK: - Private enums.

    private enum CurrentCategoryOfMovies {
        case popular
        case topRating
        case upComing
    }

    // MARK: - Private visual components.

    private let searchController = UISearchController(searchResultsController: nil)

    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = UIColor(named: Colors.backgroundColorName)
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var moviesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.backgroundColor = UIColor(named: Colors.backgroundColorName)
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(
            MovieCollectionViewCell.self,
            forCellWithReuseIdentifier: Identifier.movieCellID
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var popularButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.popularButtonText, for: .normal)
        button.backgroundColor = UIColor(named: Colors.buttonColorName)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(popularAction), for: .touchUpInside)
        return button
    }()

    private lazy var topRatedButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.topRatingButtonText, for: .normal)
        button.backgroundColor = UIColor(named: Colors.buttonColorName)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(topRatingAction), for: .touchUpInside)
        return button
    }()

    private lazy var upComingButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.upComingButtonText, for: .normal)
        button.backgroundColor = UIColor(named: Colors.buttonColorName)
        button.layer.cornerRadius = 10
        if button.isSelected {
            button.layer.borderColor = UIColor(named: Colors.favoriteMovieColorName)?.cgColor
            button.layer.borderWidth = 2
        }
        button.addTarget(self, action: #selector(upComingAction), for: .touchUpInside)
        return button
    }()

    // MARK: - Private properties.

    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }

    private var isFiltering: Bool {
        searchController.isActive && !searchBarIsEmpty
    }

    private var movies: [MovieList.Movie]? = []
    private var filteredMovies: [MovieList.Movie]? = []
    private var currentPage = 1
    private var fetchingMore = false
    private var isSearching = false
    private var currentCategoryMovies: CurrentCategoryOfMovies = .popular
    private let movieListUrlString = UrlComponent.movieBaseUrlText + UrlComponent.moviePath

    // MARK: - Life cycle.

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData(url: movieListUrlString, categoryOfMovies: UrlComponent.popularCategoryUrlText)
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

    private func fetchData(url: String, categoryOfMovies: String?) {
        fetchingMore = true
        NetworkService.shared
            .fetchResult(url: url, categoryOfMovies: categoryOfMovies, page: currentPage) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case let .success(movies):
                        guard let secureFetchMovies = movies?.movies else { return }
                        guard !secureFetchMovies.isEmpty else {
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
        guard !fetchingMore else { return }
        currentPage += 1
        fetchData(url: movieListUrlString, categoryOfMovies: UrlComponent.popularCategoryUrlText)
    }

    private func filterContentForSearch(_ searchText: String) {
        isSearching = true
        filteredMovies = movies?.filter {
            $0.title.lowercased().contains(searchText.lowercased())
        }
    }

    private func reloadMoviesList() {
        moviesCollectionView.reloadData()
    }

    private func showError(error: Error) {
        print(error.localizedDescription)
    }

    private func showDetail(id: Int) {
        let detailMovieViewController = MovieDetailViewController()
        let urlWithID = movieListUrlString + "\(id)"
        detailMovieViewController.loadMovie(urlWithID: urlWithID)
        detailMovieViewController.urlMovieID = urlWithID
        navigationController?.pushViewController(detailMovieViewController, animated: true)
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

    @objc private func popularAction(_ sender: UIButton) {
        movies?.removeAll()
        currentPage = 1
        currentCategoryMovies = .popular
        fetchData(url: movieListUrlString, categoryOfMovies: UrlComponent.popularCategoryUrlText)
    }

    @objc private func topRatingAction() {
        movies?.removeAll()
        currentPage = 1
        currentCategoryMovies = .topRating
        fetchData(url: movieListUrlString, categoryOfMovies: UrlComponent.topRatedCategoryUrlText)
    }

    @objc private func upComingAction() {
        movies?.removeAll()
        currentPage = 1
        currentCategoryMovies = .upComing
        fetchData(url: movieListUrlString, categoryOfMovies: UrlComponent.upcomingCategoryUrlText)
    }
}

extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for _: UISearchController) {
        filterContentForSearch(searchController.searchBar.text ?? "")
        reloadMoviesList()
    }

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
        if isFiltering {
            return filteredMovies?.count ?? 0
        } else {
            return movies?.count ?? 0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Identifier.movieCellID,
                for: indexPath
            ) as? MovieCollectionViewCell,
            let movie = isFiltering ? filteredMovies?[indexPath.row] : movies?[indexPath.row]
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
        if indexPath.row == movies.count - 4 {
            loadMoreMovies()
        }
    }
}

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = movies?[indexPath.row].id else { return }
        showDetail(id: id)
    }
}
