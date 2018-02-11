//
//  ATAppFlowCoordinator.swift
//  AaptivTime
//
//  Created by HAO WANG on 2/10/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import Foundation
import UIKit

class ATAppFlowCoordinator {

    var mainNavigationController: UINavigationController?
    lazy var articleListViewController: ATArticlesListViewController = {
        let ds = ATArticlesListDataSource()
        ds.fetchNYTimesTopStories()
        ds.fetchFromDatabase()
        let vm = ATArticlesListViewModel(dataSource: ds)
        let articleList = ATArticlesListViewController(viewModel: vm)
        articleList.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
        return articleList
    }()

    lazy var savedArticlesViewController: ATSavedArticlesViewController = {

        let ds = ATArticlesListDataSource(savedOnly: true)
        ds.fetchFromDatabase()
        let vm = ATArticlesListViewModel(dataSource: ds)
        let savedArticlesList = ATSavedArticlesViewController(viewModel: vm)
        savedArticlesList.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        return savedArticlesList
    }()

    lazy var tabbarController: UITabBarController = {
        let tabbar = UITabBarController()
        tabbar.title = "Top Stories"
        tabbar.view.backgroundColor = .white
        tabbar.viewControllers = [self.articleListViewController, self.savedArticlesViewController]
        return tabbar
    }()

    func isiPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    /// start the initial UI
    func launch() {
        mainNavigationController = UINavigationController(rootViewController: self.tabbarController)
        mainNavigationController?.navigationBar.prefersLargeTitles = true
        AppDelegate.sharedDelegate?.window?.rootViewController = mainNavigationController
        AppDelegate.sharedDelegate?.window?.makeKeyAndVisible()
    }

    func showArticleWeb(withArticle item: NYTimeArticleItem) {

        let articleVC = ATArticleWebViewController(articleItem: item)
        articleVC.navigationItem.largeTitleDisplayMode = .never
        mainNavigationController?.pushViewController(articleVC, animated: true)
    }
}
