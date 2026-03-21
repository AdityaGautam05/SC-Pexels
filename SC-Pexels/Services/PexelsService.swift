//
//  PexelsService.swift
//  SC-Pexels
//
//  Created by Aditya Gautam on 20/03/26.
//

import Foundation

enum PexelsError: LocalizedError, Sendable {
    case invalidURL
    case noConnection
    case rateLimited
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .invalidURL:       return "Invalid request URL."
        case .noConnection:     return "No internet connection. Please check your network."
        case .rateLimited:      return "API rate limit reached. Please try again later."
        case .invalidResponse:  return "Received an invalid response from the server."
        }
    }
}

struct PexelsService: Sendable {

    // Replace with your actual Pexels API key from https://www.pexels.com/api/
    private let apiKey = "ZIE6cdO4tODcstfSw6B4pppiDV7h6GVyKL2BcWCDxCVXqaNDMcoVZ9gb"
    private let baseURL = "https://api.pexels.com/videos/popular"

    func fetchPopularVideos(page: Int, perPage: Int) async throws -> PexelsVideoResponse {
        guard var components = URLComponents(string: baseURL) else {
            throw PexelsError.invalidURL
        }
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        guard let url = components.url else {
            throw PexelsError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        request.cachePolicy = .useProtocolCachePolicy

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw PexelsError.noConnection
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw PexelsError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200:
            break
        case 429:
            throw PexelsError.rateLimited
        default:
            throw PexelsError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(PexelsVideoResponse.self, from: data)
        } catch {
            throw PexelsError.invalidResponse
        }
    }
}
