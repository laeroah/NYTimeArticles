//
//  NYTimeArticleItem.swift
//  AaptivTime
//
//  Created by HAO WANG on 2/9/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import Foundation

struct NYTimeArticleResults: Codable {
    let results: [NYTimeArticleItem]?
}

struct NYTimeArticleItemMedia: Codable {
    var url: String?
    var format: String?
}

struct NYTimeArticleItem: Codable {

    var url: String?
    var section: String?
    var subsection: String?
    var title: String?
    var abstract: String?
    var updatedDate: Date?
    var createdDate: Date?
    var publishedDate: Date?
    var byLine: String?
    var thumbnailUrl: String?
    var saved: Bool = false

    enum CodingKeys: String, CodingKey {
        case url
        case section
        case subsection
        case title
        case abstract
        case byLine
        case updatedDate = "updated_date"
        case createdDate = "created_date"
        case publishedDate = "published_date"
        case thumbnailUrl
    }

    // nested fields
    enum MultimediaKeys: String, CodingKey {
        case multimedia
    }

    init(from decoder: Decoder) throws {
        let multimedia = try decoder.container(keyedBy: MultimediaKeys.self)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decode(String.self, forKey: .url)
        section = try values.decodeIfPresent(String.self, forKey: .section)
        subsection = try values.decodeIfPresent(String.self, forKey: .subsection)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        abstract = try values.decodeIfPresent(String.self, forKey: .abstract)
        byLine = try values.decodeIfPresent(String.self, forKey: .byLine)
        updatedDate = try values.decodeIfPresent(Date.self, forKey: .updatedDate)
        createdDate = try values.decodeIfPresent(Date.self, forKey: .createdDate)
        publishedDate = try values.decodeIfPresent(Date.self, forKey: .publishedDate)
        let medias = try multimedia.decode([NYTimeArticleItemMedia].self, forKey: .multimedia)
        for media in medias where media.format == "thumbLarge"  {
            thumbnailUrl = media.url
        }
    }

    init(withManagedObject item: ArticleItem) {

        url = item.url
        section = item.section
        subsection = item.subsection
        title = item.title
        abstract = item.abstract
        byLine = item.byLine
        updatedDate = item.updatedDate as Date?
        createdDate = item.createdDate as Date?
        publishedDate = item.publishedDate as Date?
        thumbnailUrl = item.thumbnailUrl
        saved = item.saved
    }
}
