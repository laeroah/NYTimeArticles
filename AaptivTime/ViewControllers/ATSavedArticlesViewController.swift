//
//  ATSavedArticlesViewController.swift
//  AaptivTime
//
//  Created by HAO WANG on 2/11/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import UIKit

class ATSavedArticlesViewController: ATArticlesListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupTableView() {

        tableView.register(UINib(nibName: "ATArticleListItemCell", bundle: nil),
                           forCellReuseIdentifier: ATTableCellIdentifier.articleListCell.rawValue)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150;
        tableView.delegate = self
        tableView.dataSource = self
    }
}
