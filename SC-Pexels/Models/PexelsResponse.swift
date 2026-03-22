//
//  PexelsResponse.swift
//  SC-Pexels
//
//  Created by Aditya Gautam on 20/03/26.
//

import Foundation

nonisolated struct PexelsVideoResponse: Codable, Sendable {
    let totalResults: Int
    let page: Int
    let perPage: Int
    let videos: [Video]
    let nextPage: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case totalResults = "total_results"
        case page
        case perPage = "per_page"
        case videos
        case nextPage = "next_page"
        case url
    }
}
