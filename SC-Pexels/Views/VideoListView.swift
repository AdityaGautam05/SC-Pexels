//
//  VideoListView.swift
//  SC-Pexels
//
//  Created by Aditya Gautam on 20/03/26.
//

import SwiftUI

struct VideoListView: View {

    let viewModel: VideoListViewModel
    let onVideoSelected: (Video, [Video]) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4)
    ]

    var body: some View {
        ZStack {
            if case .error(let message) = viewModel.state, viewModel.videos.isEmpty {
                VideoErrorView(message: message, onRetry: retryFetch)
            } else {
                VideoGridView(viewModel: viewModel, columns: columns, onVideoSelected: onVideoSelected)
            }

            if viewModel.state == .loading {
                ProgressView()
                    .scaleEffect(1.4)
            }
        }
        .task {
            await viewModel.fetchInitial()
        }
    }

    private func retryFetch() {
        Task { await viewModel.fetchInitial() }
    }
}

// MARK: - VideoGridView

private struct VideoGridView: View {

    let viewModel: VideoListViewModel
    let columns: [GridItem]
    let onVideoSelected: (Video, [Video]) -> Void

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(viewModel.videos) { video in
                    VideoCardView(video: video) {
                        onVideoSelected(video, viewModel.videos)
                    }
                    .onAppear {
                        if viewModel.hasMore, video.id == viewModel.videos.last?.id {
                            Task { await viewModel.loadMore() }
                        }
                    }
                }
            }
            .padding(.horizontal, 4)
            .padding(.top, 4)

            if viewModel.state == .loadingMore {
                ProgressView()
                    .padding(.vertical, 16)
            }
        }
    }
}

// MARK: - VideoErrorView

private struct VideoErrorView: View {

    let message: String
    let onRetry: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label("Unable to Load Videos", systemImage: "wifi.slash")
        } description: {
            Text(message)
        } actions: {
            Button("Try Again", action: onRetry)
                .buttonStyle(.borderedProminent)
        }
    }
}

