//
//  NYTimeArticleItem.swift
//  AaptivTime
//
//  Created by HAO WANG on 2/9/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import Foundation

struct NYTimeArticleItem {

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

    init(withJSON json: [String: Any], dateFormatter formatter: DateFormatter) {

        url = json["url"] as? String
        section = json["section"] as? String
        subsection = json["subsection"] as? String
        title = json["title"] as? String
        abstract = json["abstract"] as? String
        byLine = json["byline"] as? String
        if let updateDateString = json["updated_date"] as? String {
            updatedDate = formatter.date(from: updateDateString)
        }
        if let createdDateString = json["created_date"] as? String {
            createdDate = formatter.date(from: createdDateString)
        }
        if let publishedString = json["published_date"] as? String {
            publishedDate = formatter.date(from: publishedString)
        }
        if let multimedia = json["multimedia"] as? [[String: Any]] {
            // due to time constraint, only considering `thumbLarge` for now
            // best practice should be adding each media item separately in an array
            // and storing them into database as separate entity
            for media in multimedia where media["format"] as? String == "thumbLarge"  {
                thumbnailUrl = media["url"] as? String
            }
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
    }
}
