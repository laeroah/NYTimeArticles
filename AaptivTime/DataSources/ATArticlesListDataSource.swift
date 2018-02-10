//
//  ATArticlesListDataSource.swift
//  AaptivTime
//
//  Created by HAO WANG on 2/8/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import Foundation
import CoreData

/// DataSource for providing article list
final class ATArticlesListDataSource: NSObject, ATArticleListDataSourceable {

    let apiService: ATNYTimeAPIService
    let coredataService: ATCoreDataService

    var contentWillChange: (()->())?
    var contentDidChange: (()->())?
    var sectionDidInsert: ((String, Int)->())?
    var sectionDidDelete: ((String, Int)->())?
    var articleDidInsert: ((NYTimeArticleItem, IndexPath)->())?
    var articleDidDelete: ((NYTimeArticleItem, IndexPath)->())?
    var articleDidUpdate: ((NYTimeArticleItem, IndexPath)->())?
    var articleDidMove: ((NYTimeArticleItem, IndexPath, IndexPath)->())?

    // MARK: initializers
    init(withAPIService api: ATNYTimeAPIService,
         withCoreDataService coredata: ATCoreDataService) {
        self.apiService = api
        self.coredataService = coredata
        super.init()
    }

    convenience override init() {
        let apiService = ATNYTimeAPIService()
        let coredataService = ATCoreDataService()
        self.init(withAPIService: apiService,
                  withCoreDataService: coredataService)
    }

    // MARK: lazy properties
    private lazy var fetchResultsController: NSFetchedResultsController<ArticleItem>? = {
        let request: NSFetchRequest<ArticleItem> = ArticleItem.fetchRequest()
        let sectionSort = NSSortDescriptor(key: "section", ascending: true)
        let publishedDateSort = NSSortDescriptor(key: "publishedDate", ascending: true)
        request.sortDescriptors = [sectionSort, publishedDateSort]

        guard let moc = AppDelegate.sharedDelegate?.persistentContainer.viewContext else {
            return nil
        }
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: "section", cacheName: "com.articletable.list")
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
}

// MARK: interfaces
extension ATArticlesListDataSource {
    func fetchNYTimesTopStories(complete: ((APIServiceError?)->())? = nil) {
        apiService.fetchTopStories { [weak self] (items, error) in
            if let articles = items {
                self?.coredataService.saveArticleItems(articles)
            }
            complete?(error)
        }
    }

    func fetchFromDatabase() {
        do {
            try self.fetchResultsController?.performFetch()
        } catch {
            log.error("failed initialize NSFetchedResultsController: \(error)")
        }
    }

    func numberOfItems(forSection section: Int) -> Int {

        guard let sections = self.fetchResultsController?.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    func numberOfSections() -> Int {
        return self.fetchResultsController?.sections?.count ?? 0
    }

    func item(forSection section: Int, forRow row: Int) -> NYTimeArticleItem? {

        let indexPath = IndexPath(row: row, section: section)
        guard let managedArticleItem = self.fetchResultsController?.object(at: indexPath) else {
            return nil
        }
        return NYTimeArticleItem(withManagedObject: managedArticleItem)
    }
}

// MARK: NSFetchedResultsControllerDelegate
extension ATArticlesListDataSource: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.contentWillChange?()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.contentDidChange?()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

        let sectionTitle = sectionInfo.name
        switch type {
        case .insert:
            self.sectionDidInsert?(sectionTitle, sectionIndex)
        case .delete:
            self.sectionDidDelete?(sectionTitle, sectionIndex)
        case .move:
            break
        case .update:
            break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        guard let managedItem = anObject as? ArticleItem else {
            log.error("unexpected NSFetchedResultsController return type")
            return
        }

        let article = NYTimeArticleItem(withManagedObject: managedItem)

        switch type {
        case .insert:
            self.articleDidInsert?(article, newIndexPath!)
        case .delete:
            self.articleDidDelete?(article, indexPath!)
        case .update:
            self.articleDidUpdate?(article, indexPath!)
        case .move:
            self.articleDidMove?(article, indexPath!, newIndexPath!)
        }
    }
}
