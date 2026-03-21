//
//  Video.swift
//  SC-Pexels
//
//  Created by Aditya Gautam on 20/03/26.
//

import Foundation

struct VideoUser: Codable, Sendable, Hashable {
    let id: Int
    let name: String
    let url: String
}

struct VideoFile: Codable, Sendable, Hashable {
    let id: Int
    let quality: String
    let file_type: String
    let width: Int?
    let height: Int?
    let fps: Double?
    let link: String
}

struct Video: Codable, Sendable, Identifiable, Hashable {
    let id: Int
    let width: Int
    let height: Int
    let url: String
    let image: String
    let duration: Int
    let user: VideoUser
    let video_files: [VideoFile]
}
