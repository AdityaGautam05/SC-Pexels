//
//  PexelsResponse.swift
//  SC-Pexels
//
//  Created by Aditya Gautam on 20/03/26.
//

import Foundation

nonisolated struct PexelsVideoResponse: Codable, Sendable {
    let total_results: Int
    let page: Int
    let per_page: Int
    let videos: [Video]
    let next_page: String?
    let url: String?
}
