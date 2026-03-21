//
//  NextUpRowView.swift
//  SC-Pexels
//
//  Created by Aditya Gautam on 20/03/26.
//

import SwiftUI

struct NextUpRowView: View {

    let video: Video
    let isPlaying: Bool

    var body: some View {
        HStack(spacing: 14) {
            // Thumbnail — size-locked 16:9 at 96pt wide
            Color.clear
                .aspectRatio(16.0 / 9.0, contentMode: .fit)
                .frame(width: 96)
                .overlay {
                    AsyncImage(url: URL(string: video.image)) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().scaledToFill()
                        case .failure:
                            Color.gray.opacity(0.2)
                                .overlay {
                                    Image(systemName: "photo")
                                        .accessibilityHidden(true)
                                        .foregroundStyle(.tertiary)
                                }
                        default:
                            Color.gray.opacity(0.1)
                                .overlay(ProgressView().scaleEffect(0.7))
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                }
                .clipShape(.rect(cornerRadius: 8, style: .continuous))

            VStack(alignment: .leading, spacing: 3) {
                Text(video.user.name)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text(Duration.seconds(video.duration), format: .time(pattern: .minuteSecond))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if isPlaying {
                Image(systemName: "waveform")
                    .symbolEffect(.variableColor.iterative)
                    .font(.callout)
                    .foregroundStyle(.tint)
                    .accessibilityLabel("Now playing")
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(isPlaying ? Color.accentColor.opacity(0.06) : Color.clear)
    }
}

