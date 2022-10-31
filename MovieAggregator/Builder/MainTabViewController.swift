// MainTabViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Controller with movies tab sections.
final class MainTabViewController: UITabBarController {
    // MARK: - Private Constants.

    private enum Constants {
        static let tabMoviesTitleName = "Фильмы"
        static let tabMoviesImageName = "popcorn.circle.fill"
        static let favoriteTitleName = "Избранное"
        static let tabFavoriteImageName = "star"
    }

    // MARK: - Life cycle.

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTabBar()
    }

    // MARK: - Private methods.

    private func setupUI() {
        setupNavViewControllers()
    }

    private func configureTabBar() {
        view.backgroundColor = UIColor(named: Colors.backgroundColorName)
        UITabBar.appearance().backgroundColor = UIColor(named: Colors.tabBarBackgroundColorName)
        tabBar.tintColor = UIColor(named: Colors.tintColorName)
    }

    private func setupNavViewControllers() {
        viewControllers = [
            createNavigationController(
                for: MovieListViewController(),
                title: Constants.tabMoviesTitleName,
                imageName: Constants.tabMoviesImageName
            ),
            createNavigationController(
                for: FavoriteViewController(),
                title: Constants.favoriteTitleName,
                imageName: Constants.tabFavoriteImageName
            ),
        ]
    }

    private func setupNavigationBarColorAppearance(navigationController: UINavigationController) {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: Colors.navigationBarColorName)
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }

    private func createNavigationController(
        for rootViewController: UIViewController,
        title: String,
        imageName: String
    ) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = UIImage(systemName: imageName)
        navigationController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        setupNavigationBarColorAppearance(navigationController: navigationController)
        return navigationController
    }
}
