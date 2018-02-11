//
//  ATArticlesListViewModel.swift
//  AaptivTime
//
//  Created by HAO WANG on 2/8/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import Foundation
import CoreData

/// View model for the article list view. It monitors database changes and updates
/// the article list as well as the sections scroll
final class ATArticlesListViewModel: NSObject {

    var currentSelectedSection: ATDynamicType<Int> = ATDynamicType(0)
    var isFetchingData: ATDynamicType<Bool> = ATDynamicType(false)
    var error: ATDynamicType<APIServiceError?> = ATDynamicType(nil)

    var contentWillChange: (()->())? {
        didSet {
            dataSource.contentWillChange = contentWillChange
        }
    }
    var contentDidChange: (()->())? {
        didSet {
            dataSource.contentDidChange = contentDidChange
        }
    }
    var sectionDidInsert: ((String, Int)->())? {
        didSet {
            dataSource.sectionDidInsert = sectionDidInsert
        }
    }
    var sectionDidDelete: ((String, Int)->())? {
        didSet {
            dataSource.sectionDidDelete = sectionDidDelete
        }
    }
    var articleDidInsert: ((NYTimeArticleItem, Int)->())?
    var articleDidDelete: ((NYTimeArticleItem, Int)->())?
    var articleDidUpdate: ((NYTimeArticleItem, Int)->())?
    var articleDidMove: ((NYTimeArticleItem, Int, Int)->())?

    var dataSource: ATArticleListDataSourceable

    init(dataSource ds: ATArticleListDataSourceable) {
        dataSource = ds
        super.init()
        dataSource.articleDidInsert = { [weak self] (item, indexPath) in
            if indexPath.section == self?.currentSelectedSection.value {
                self?.articleDidInsert?(item, indexPath.row)
            }
        }
        dataSource.articleDidDelete = { [weak self] (item, indexPath) in
            if indexPath.section == self?.currentSelectedSection.value {
                self?.articleDidDelete?(item, indexPath.row)
            }
        }
        dataSource.articleDidUpdate = { [weak self] (item, indexPath) in
            if indexPath.section == self?.currentSelectedSection.value {
                self?.articleDidUpdate?(item, indexPath.row)
            }
        }
        dataSource.articleDidMove = { [weak self] (item, fromIndexPath, toIndexPath) in
            if fromIndexPath.section == self?.currentSelectedSection.value &&
                toIndexPath.section == self?.currentSelectedSection.value {
                self?.articleDidMove?(item, fromIndexPath.row, toIndexPath.row)
            }
        }
    }

    func updateSelectedSection(_ section: Int) {
        currentSelectedSection.value = section
    }

    func fetchLatestTopStories() {
        isFetchingData.value = true
        dataSource.fetchNYTimesTopStories { [weak self](error) in
            if let err = error {
                self?.error.value = err
            }
            self?.isFetchingData.value = false
        }
    }
}

extension ATArticlesListViewModel {

    func numberOfSections() -> Int {
        return dataSource.numberOfSections()
    }

    func numberOfRows() -> Int {
        return dataSource.numberOfItems(forSection: currentSelectedSection.value)
    }

    func articleItem(at indexPath: IndexPath) -> NYTimeArticleItem? {
        return dataSource.item(forSection: currentSelectedSection.value,
                               forRow: indexPath.row)
    }

    func sectionName(at index: Int) -> String {
        return dataSource.sectionName(at: index)
    }
}
