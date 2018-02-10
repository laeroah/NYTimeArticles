//
//  ATArticleItemViewModel.swift
//  AaptivTime
//
//  Created by HAO WANG on 2/10/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import Foundation

class ATArticleItemViewModel {

    let articleItem: NYTimeArticleItem
    lazy var dateLabel: String = {
        return articleItem.publishedDate?.shortArticleDateLabelString() ?? ""
    }()

    init(_ item: NYTimeArticleItem) {
        articleItem = item
    }
}
