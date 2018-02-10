//
//  ATArticleListDataSourceable.swift
//  AaptivTime
//
//  Created by HAO WANG on 2/10/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import Foundation

protocol ATArticleListDataSourceable {

    // MARK: binding the data changes
    var contentWillChange: (()->())? { get set }
    var contentDidChange: (()->())? { get set }
    var sectionDidInsert: ((String, Int)->())? { get set }
    var sectionDidDelete: ((String, Int)->())? { get set }
    var articleDidInsert: ((NYTimeArticleItem, IndexPath)->())? { get set }
    var articleDidDelete: ((NYTimeArticleItem, IndexPath)->())? { get set }
    var articleDidUpdate: ((NYTimeArticleItem, IndexPath)->())? { get set }
    var articleDidMove: ((NYTimeArticleItem, IndexPath, IndexPath)->())? { get set }

    // MARK: fetching and getting data
    func fetchNYTimesTopStories(complete: ((APIServiceError?)->())?)
    func fetchFromDatabase()
    func numberOfItems(forSection section: Int) -> Int
    func numberOfSections() -> Int
    func item(forSection section: Int, forRow row: Int) -> NYTimeArticleItem?
}
