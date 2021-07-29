//
//  Characters.swift
//  Superheros
//
//  Created by Mbusi Hlatshwayo on 7/27/21.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let characterResponse = try? newJSONDecoder().decode(CharacterResponse.self, from: jsonData)

import Foundation

// MARK: - CharacterResponse
struct CharacterResponse: Codable {
    let code: Int?
    let status, copyright, attributionText, attributionHTML: String?
    let etag: String?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let offset, limit, total, count: Int?
    let results: [Character]?
}

// MARK: - Result
struct Character: Codable, Hashable {
    
    let uuid = UUID()
    let id: Int?
    let name, bio: String?
    let modified: String?
    let thumbnail: Thumbnail?
    let resourceURI: String?
    let comics, series: Comics?
    let events: Comics?
    let urls: [URLElement]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case bio = "description"
        case modified, thumbnail, resourceURI, comics, series, events, urls
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Character, rhs: Character) -> Bool {
         return lhs.id == rhs.id
    }
}

// MARK: - Comics
struct Comics: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [ComicsItem]?
    let returned: Int?
}

// MARK: - ComicsItem
struct ComicsItem: Codable {
    let resourceURI: String?
    let name: String?
}

enum ItemType: String, Codable {
    case backcovers = "backcovers"
    case cover = "cover"
    case interiorStory = "interiorStory"
    case pinup = "pinup"
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path: String?
    let thumbnailExtension: String?

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

// MARK: - URLElement
struct URLElement: Codable {
    let type: URLType?
    let url: String?
}

enum URLType: String, Codable {
    case comiclink = "comiclink"
    case detail = "detail"
    case wiki = "wiki"
}
