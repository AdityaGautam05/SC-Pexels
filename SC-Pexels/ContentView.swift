//
//  ContentView.swift
//  SC-Pexels
//
//  Created by Aditya Gautam on 20/03/26.
//

import SwiftUI
import UIKit

struct ContentView: View {

    @State private var coordinator = AppCoordinator()

    var body: some View {
        NavigationControllerRepresentable(coordinator: coordinator)
            .ignoresSafeArea()
    }
}

/// Bridges UINavigationController into the SwiftUI view hierarchy.
/// The coordinator owns navigation — SwiftUI owns only this thin wrapper.
private struct NavigationControllerRepresentable: UIViewControllerRepresentable {

    let coordinator: AppCoordinator

    func makeUIViewController(context: Context) -> UINavigationController {
        // Return the nav controller only — do NOT call start() here.
        return coordinator.navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // Called after the VC is embedded — safe for @Observable rendering.
        guard uiViewController.viewControllers.isEmpty else { return }
        coordinator.start()
    }
}

#Preview {
    ContentView()
}

