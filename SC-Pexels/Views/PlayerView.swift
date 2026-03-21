//
//  PlayerView.swift
//  SC-Pexels
//
//  Created by Aditya Gautam on 20/03/26.
//

import SwiftUI
import AVKit

struct PlayerView: View {

    let viewModel: PlayerViewModel
    let onSelectVideo: (Int) -> Void

    var body: some View {
        VStack(spacing: 0) {
            VideoPlayer(player: viewModel.player)
                // 55% of screen height
                .containerRelativeFrame(.vertical) { h, _ in h * 0.55 }

            NextUpListView(
                queue: viewModel.queue,
                currentVideo: viewModel.currentVideo,
                currentIndex: viewModel.currentIndex,
                onSelectVideo: onSelectVideo
            )
        }
        .background(.ultraThinMaterial)
        .navigationTitle(viewModel.currentVideo?.user.name ?? "Now Playing")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

// MARK: - NextUpListView

private struct NextUpListView: View {

    let queue: [Video]
    let currentVideo: Video?
    let currentIndex: Int
    let onSelectVideo: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Next Up")
                    .font(.headline)
                if let current = currentVideo {
                    Text("· \(current.user.name)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 10)

            Divider().padding(.horizontal, 20)

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(queue.indices, id: \.self) { index in
                        Button {
                            onSelectVideo(index)
                        } label: {
                            NextUpRowView(video: queue[index], isPlaying: index == currentIndex)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

