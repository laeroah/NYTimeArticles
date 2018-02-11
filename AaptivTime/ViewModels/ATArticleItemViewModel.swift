//
//  ATArticleItemViewModel.swift
//  AaptivTime
//
//  Created by HAO WANG on 2/10/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import Foundation

class ATArticleItemViewModel {

    var saved: ATDynamicType<Bool> = ATDynamicType(false)
    var articleItem: NYTimeArticleItem
    var dataSource: ATArticleListDataSourceable?

    lazy var dateLabel: String = {
        return articleItem.publishedDate?.shortArticleDateLabelString() ?? ""
    }()

    init(_ item: NYTimeArticleItem) {
        articleItem = item
        saved.value = item.saved
    }

    func saveButtonPress() {
        dataSource?.coredataService.saveArticle(articleItem)
        saved.value = true
    }

    func unsaveButtonPress() {
        dataSource?.coredataService.unsaveArticle(articleItem)
        saved.value = false
    }
}
