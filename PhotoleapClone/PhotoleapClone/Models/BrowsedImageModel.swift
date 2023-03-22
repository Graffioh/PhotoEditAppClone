import Foundation
import SwiftUI

struct BrowsedImageModel: Codable, Identifiable, Hashable {
    let id: Int
    var width: Int
    var height: Int
    let url: String
    let photographer: String
    let photographer_url: String
    let photographer_id: Int
    let avg_color: String
    let src: BrowsedImageSources
}

struct BrowsedImageResponse: Codable {
    var page: Int
    var per_page: Int
    var photos: [BrowsedImageModel]
}

struct BrowsedImageSources: Codable, Hashable {
    let original: String
    let large2x: String
    let large: String
    let medium: String
    let small: String
    let portrait: String
    let landscape: String
    let tiny: String
}

