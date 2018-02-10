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

    var articleSections: ATDynamicType<[String]> = ATDynamicType([])
    var currentSelectedSection: ATDynamicType<Int> = ATDynamicType(0)

    let dataSource: ATArticleListDataSourceable

    init(dataSource ds: ATArticleListDataSourceable) {
        dataSource = ds
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
        return dataSource.item(forSection: indexPath.section, forRow: indexPath.row)
    }
}
