//
//  VideoListViewModel.swift
//  SC-Pexels
//
//  Created by Aditya Gautam on 20/03/26.
//

import Observation
import Foundation

enum ViewState: Equatable {
    case idle
    case loading
    case loadingMore
    case loaded
    case error(String)
}

@Observable
final class VideoListViewModel {

    // MARK: - Published State

    var videos: [Video] = []
    var state: ViewState = .idle
    private(set) var hasMore = true

    // MARK: - Private

    private var currentPage = 1
    private let perPage = 15
    private let service = PexelsService()

    // MARK: - Public API

    func fetchInitial() async {
        guard state != .loading else { return }
        videos = []
        currentPage = 1
        hasMore = true
        await load()
    }

    func loadMore() async {
        guard state != .loading, state != .loadingMore, hasMore else { return }
        await load()
    }

    // MARK: - Private

    private func load() async {
        state = videos.isEmpty ? .loading : .loadingMore
        do {
            let response = try await service.fetchPopularVideos(page: currentPage, perPage: perPage)
            videos.append(contentsOf: response.videos)
            currentPage += 1
            hasMore = response.nextPage != nil
            state = .loaded
        } catch {
            state = .error((error as? PexelsError)?.errorDescription ?? error.localizedDescription)
        }
    }
}
