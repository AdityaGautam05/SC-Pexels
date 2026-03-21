//
//  PlayerViewModel.swift
//  SC-Pexels
//
//  Created by Aditya Gautam on 20/03/26.
//

import AVKit
import Observation

@Observable
final class PlayerViewModel {

    // MARK: - Published State

    let player: AVPlayer
    var queue: [Video]
    var currentIndex: Int

    // MARK: - Computed

    var currentVideo: Video? {
        queue.indices.contains(currentIndex) ? queue[currentIndex] : nil
    }

    // MARK: - Private

   private var endObserverTask: Task<Void, Never>?

    // MARK: - Init

    init(video: Video, queue: [Video]) {
        let startIndex = queue.firstIndex(where: { $0.id == video.id }) ?? 0
        self.queue = queue
        self.currentIndex = startIndex
        self.player = AVPlayer()

        let urlString = Self.bestVideoURL(video)
        if let url = URL(string: urlString), !urlString.isEmpty {
            player.replaceCurrentItem(with: AVPlayerItem(url: url))
            player.play()
            startEndObserver()
        }
    }

    deinit {
        // @MainActor classes are always deallocated on the main actor.
        // assumeIsolated lets deinit (nonisolated by language rule) access
        // the main-actor-isolated property to cancel the running task.
        MainActor.assumeIsolated {
            endObserverTask?.cancel()
        }
    }

    // MARK: - Public API

    func play(at index: Int) {
        guard queue.indices.contains(index) else { return }
        currentIndex = index
        let video = queue[index]
        let urlString = Self.bestVideoURL(video)
        guard let url = URL(string: urlString), !urlString.isEmpty else { return }
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
        player.play()
        startEndObserver()
    }

    func playNext() {
        let nextIndex = currentIndex + 1
        guard nextIndex < queue.count else { return }
        play(at: nextIndex)
    }

    // MARK: - End-of-video Observer

    private func startEndObserver() {
        endObserverTask?.cancel()
        guard let currentItem = player.currentItem else { return }

        endObserverTask = Task { [weak self] in
            let notifications = NotificationCenter.default.notifications(
                named: AVPlayerItem.didPlayToEndTimeNotification,
                object: currentItem
            )
            for await _ in notifications {
                self?.playNext()
                break // one-shot; playNext() restarts the observer for the new item
            }
        }
    }

    // MARK: - Helpers

    /// Selects the best available video file URL.
    /// Priority: HD → SD → first available.
    private static func bestVideoURL(_ video: Video) -> String {
        let preferred = ["hd", "sd", "uhd", "mobile"]
        for quality in preferred {
            if let file = video.video_files.first(where: { $0.quality == quality && $0.file_type == "video/mp4" }) {
                return file.link
            }
        }
        return video.video_files.first?.link ?? ""
    }
}
