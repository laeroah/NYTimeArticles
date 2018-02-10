//
//  ArticleItem+CoreDataProperties.swift
//  
//
//  Created by HAO WANG on 2/9/18.
//
//

import Foundation
import CoreData


extension ArticleItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleItem> {
        return NSFetchRequest<ArticleItem>(entityName: "ArticleItem")
    }

    @NSManaged public var url: String?
    @NSManaged public var section: String?
    @NSManaged public var subsection: String?
    @NSManaged public var title: String?
    @NSManaged public var abstract: String?
    @NSManaged public var updatedDate: NSDate?
    @NSManaged public var createdDate: NSDate?
    @NSManaged public var publishedDate: NSDate?
    @NSManaged public var byLine: String?
    @NSManaged public var saved: Bool
    @NSManaged public var thumbnailUrl: String?
}
