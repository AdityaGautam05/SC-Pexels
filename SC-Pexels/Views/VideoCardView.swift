//
//  VideoCardView.swift
//  SC-Pexels
//
//  Created by Aditya Gautam on 20/03/26.
//

import SwiftUI

struct VideoCardView: View {

    let video: Video
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            // Color.clear owns the size
            Color.clear
                .aspectRatio(9.0 / 16.0, contentMode: .fit)
                .overlay { VideoCardThumbnail(url: video.image) }
                .overlay(alignment: .bottom) {
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.65)],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                }
                .overlay(alignment: .bottom) {
                    VideoCardMetadata(name: video.user.name, duration: video.duration)
                }
                .clipShape(.rect(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - VideoCardThumbnail

private struct VideoCardThumbnail: View {

    let url: String

    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                Color.gray.opacity(0.25)
                    .overlay {
                        Image(systemName: "photo")
                            .accessibilityHidden(true)
                            .foregroundStyle(.white.opacity(0.5))
                    }
            default:
                Color.gray.opacity(0.12)
                    .overlay(ProgressView())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }
}

// MARK: - VideoCardMetadata

private struct VideoCardMetadata: View {

    let name: String
    let duration: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(name)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .lineLimit(1)

            Text(Duration.seconds(duration), format: .time(pattern: .minuteSecond))
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 6)
        .padding(.bottom, 8)
    }
}

