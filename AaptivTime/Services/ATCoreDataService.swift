//
//  ATCoreDataService.swift
//  AaptivTime
//
//  Created by HAO WANG on 2/8/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import Foundation
import CoreData

final class ATCoreDataService {

    private static var writingContext: NSManagedObjectContext? {

        if let mainContext = AppDelegate.sharedDelegate?
            .persistentContainer.viewContext {

            let context =
                NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

            context.parent = mainContext
            return context
        }

        return nil
    }

    private func performCoreDataUpdate(_ changes: @escaping (_ context: NSManagedObjectContext)->()) {

        guard let context = ATCoreDataService.writingContext else {
            return
        }

        context.perform({
            changes(context)
            do {
                try context.save()
                context.parent?.performAndWait({
                    do {
                        try context.parent?.save()
                    } catch {
                        // we should handle this error better in real app
                        log.error("Failure to save context: \(error)")
                    }
                })
            } catch {
                // we should handle this error better in real app
                log.error("Failure to save context: \(error)")
            }
        })
    }

    /// Save article items to database
    func saveArticleItems(_ items: [NYTimeArticleItem]) {
        performCoreDataUpdate { (context) in
            for item in items {
                ArticleItem.createArticleItem(item, inContext: context)
            }
        }
    }
}
