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
    let fileType: String
    let width: Int?
    let height: Int?
    let fps: Double?
    let link: String
    
    enum CodingKeys: String, CodingKey {
        case id, quality, fileType = "file_type", width, height, fps, link
    }
}

struct Video: Codable, Sendable, Identifiable, Hashable {
    let id: Int
    let width: Int
    let height: Int
    let url: String
    let image: String
    let duration: Int
    let user: VideoUser
    let videoFiles: [VideoFile]
    
    enum CodingKeys: String, CodingKey {
        case id, width, height, url, image, duration, user, videoFiles = "video_files"
    }
}
