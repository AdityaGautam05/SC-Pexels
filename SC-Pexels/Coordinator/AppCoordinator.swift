//
//  AppCoordinator.swift
//  SC-Pexels
//
//  Created by Aditya Gautam on 20/03/26.
//

import UIKit
import SwiftUI

/// Owns the UINavigationController and drives all screen transitions.
/// SwiftUI views have no navigation logic — they fire callbacks that
/// this coordinator handles.

/// UIHostingController subclass that keeps the status bar visible
/// and sets a clear background so .ultraThinMaterial shows through.
private final class PlayerHostingController<Content: View>: UIHostingController<Content> {
    override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
}

final class AppCoordinator {

    let navigationController: UINavigationController = {
        let nav = UINavigationController()
        nav.navigationBar.prefersLargeTitles = true
        return nav
    }()

    // MARK: - Entry Point

    func start() {
        showVideoList()
    }

    // MARK: - Navigation

    private func showVideoList() {
        let viewModel = VideoListViewModel()
        let listView = VideoListView(viewModel: viewModel) { [weak self] video, queue in
            self?.showPlayer(video: video, queue: queue)
        }
        let hostingController = UIHostingController(rootView: listView)
        hostingController.title = "Popular Videos"
        navigationController.setViewControllers([hostingController], animated: false)
    }

    private func showPlayer(video: Video, queue: [Video]) {
        let viewModel = PlayerViewModel(video: video, queue: queue)
        let playerView = PlayerView(viewModel: viewModel) { index in
            viewModel.play(at: index)
        }
        let hostingController = PlayerHostingController(rootView: playerView)
        hostingController.title = video.user.name
        navigationController.pushViewController(hostingController, animated: true)
    }
}
