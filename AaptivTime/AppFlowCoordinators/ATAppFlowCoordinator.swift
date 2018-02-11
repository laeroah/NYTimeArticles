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
    var articleListViewController: ATArticlesListViewController?

    func isiPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    /// start the initial UI
    func launch() {
        if isiPhone() {
            let ds = ATArticlesListDataSource()
            ds.fetchFromDatabase()
            let vm = ATArticlesListViewModel(dataSource: ds)
            let articleList = ATArticlesListViewController(viewModel: vm)
            mainNavigationController = UINavigationController(rootViewController: articleList)
            mainNavigationController?.navigationBar.prefersLargeTitles = true
            articleListViewController = articleList
            AppDelegate.sharedDelegate?.window?.rootViewController = mainNavigationController
            AppDelegate.sharedDelegate?.window?.makeKeyAndVisible()
        }
    }

    func showArticleWeb(withArticle item: NYTimeArticleItem) {

        let articleVC = ATArticleWebViewController(articleItem: item)
        articleVC.navigationItem.largeTitleDisplayMode = .never
        mainNavigationController?.pushViewController(articleVC, animated: true)
    }
}
