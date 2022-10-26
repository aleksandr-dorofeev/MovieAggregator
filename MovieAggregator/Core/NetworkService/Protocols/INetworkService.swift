// INetworkService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Protocol for network layer.
protocol INetworkService {
    func getMovies(categoryOfMovies: String, page: Int, _ completion: @escaping (Result<MovieList?, Error>) -> Void)
}
