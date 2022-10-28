// NetworkService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Network service layer.
final class NetworkService {
    // MARK: - Private enums.

    private enum UrlComponent {
        static let genrePath = "genre/"
        static let apiKeyValueText = "8216e974d625f2a458a739c20007dcd6"
        static let posterPathImageUrl = "https://image.tmdb.org/t/p/w500"
        static let languageValueText = "ru-RU"
        static let regionValueText = "ru"
    }

    private enum QueryItems {
        static let languageQueryText = "language"
        static let regionQueryText = "region"
        static let apiKeyQueryText = "api_key"
        static let pageQueryText = "page"
    }

    // MARK: - Singleton.

    static let shared = NetworkService()

    // MARK: - Private properties.

    private let session = URLSession.shared

    // MARK: - Public methods.

    func fetchResult(
        url: String,
        categoryOfMovies: String?,
        page: Int,
        completion: @escaping (Result<MovieList?, Error>) -> Void
    ) {
        getJson(url: url, categoryOfMovies: categoryOfMovies, page: page, completion: completion)
    }

    func fetchDetails(
        url: String,
        completion: @escaping (Result<MovieDetail?, Error>) -> Void
    ) {
        getJson(url: url, categoryOfMovies: nil, page: nil, completion: completion)
    }

    func fetchCast(
        for url: String,
        completion: @escaping (Result<CastResult?, Error>) -> Void
    ) {
        getJson(url: url, categoryOfMovies: nil, page: nil, completion: completion)
    }

    // MARK: - Private methods.

    private func getJson<T: Decodable>(
        url: String,
        categoryOfMovies: String?,
        page: Int?,
        completion: @escaping (Result<T?, Error>) -> Void
    ) {
        guard var urlComponents = URLComponents(
            string: url + (categoryOfMovies ?? "")
        )
        else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: QueryItems.apiKeyQueryText, value: UrlComponent.apiKeyValueText),
            URLQueryItem(name: QueryItems.languageQueryText, value: UrlComponent.languageValueText),
            URLQueryItem(name: QueryItems.regionQueryText, value: UrlComponent.regionValueText)
        ]
        if page != nil {
            urlComponents.queryItems?.append(URLQueryItem(name: QueryItems.pageQueryText, value: "\(page ?? 0)"))
        }
        guard let url = urlComponents.url else { return }
        session.dataTask(with: url) { jsonData, _, error in
            guard let data = jsonData else { return }
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let decoder = JSONDecoder()
                let movies = try decoder.decode(T.self, from: data)
                completion(.success(movies))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
