// NetworkService.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Network service layer.
final class NetworkService: INetworkService {
    private enum UrlComponent {
        static let movieBaseUrlText = "https://api.themoviedb.org/3/movie/"
        static let apiKeyValueText = "8216e974d625f2a458a739c20007dcd6"
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

    // MARK: - Public methods.

    func getMovies(
        categoryOfMovies: String,
        page: Int,
        _ completion: @escaping (Result<MovieList?, Error>) -> Void
    ) {
        guard var urlComponents = URLComponents(
            string: UrlComponent.movieBaseUrlText + categoryOfMovies
        )
        else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: QueryItems.apiKeyQueryText, value: UrlComponent.apiKeyValueText),
            URLQueryItem(name: QueryItems.languageQueryText, value: UrlComponent.languageValueText),
            URLQueryItem(name: QueryItems.regionQueryText, value: UrlComponent.regionValueText),
            URLQueryItem(name: QueryItems.pageQueryText, value: "\(page)"),
        ]
//        print(urlComponents)
        guard let url = urlComponents.url else { return }
        URLSession.shared.dataTask(with: url) { jsonData, _, error in
            guard let data = jsonData else { return }
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let decoder = JSONDecoder()
                let obj = try decoder.decode(MovieList.self, from: data)
                completion(.success(obj))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func downLoadImage(url: String, completion: @escaping (_ image: UIImage) -> Void) {
        guard let url = URL(string: url) else { return }

        let session = URLSession.shared
        session.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }.resume()
    }
}
