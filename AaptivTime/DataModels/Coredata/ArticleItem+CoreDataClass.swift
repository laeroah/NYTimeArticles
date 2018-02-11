//
//  ArticleItem+CoreDataClass.swift
//  
//
//  Created by HAO WANG on 2/9/18.
//
//

import Foundation
import CoreData

@objc(ArticleItem)
public class ArticleItem: NSManagedObject {

    static func fetchRequest(url: String?) -> NSFetchRequest<ArticleItem> {
        guard let urlString = url else {
            return self.fetchRequest()
        }
        let request: NSFetchRequest<ArticleItem> = ArticleItem.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", urlString)
        request.fetchLimit = 1
        return request
    }

    static func createArticleItem(_ item: NYTimeArticleItem,
                                  inContext context: NSManagedObjectContext) {


        let request: NSFetchRequest<ArticleItem> = ArticleItem.fetchRequest(url: item.url)

        do {
            let fetchedItem = try context.fetch(request).first
            let managedItem = fetchedItem ?? ArticleItem(context: context)
            managedItem.abstract = item.abstract
            managedItem.byLine = item.byLine
            managedItem.createdDate = item.createdDate as NSDate?
            managedItem.publishedDate = item.publishedDate as NSDate?
            managedItem.updatedDate = item.updatedDate as NSDate?
            managedItem.url = item.url
            managedItem.section = item.section
            managedItem.subsection = item.subsection
            managedItem.title = item.title
            managedItem.thumbnailUrl = item.thumbnailUrl

        } catch {
            fatalError("Failed to fetch article: \(error)")
        }
    }

    static func findItem(byUrl url: String,
                         inContext context: NSManagedObjectContext) -> ArticleItem? {

        let request: NSFetchRequest<ArticleItem> = ArticleItem.fetchRequest(url: url)
        let items = try? context.fetch(request)
        return items?.first
    }
}
