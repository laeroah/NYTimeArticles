//
//  ATArticlesListViewController.swift
//  AaptivTime
//
//  Created by HAO WANG on 2/10/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import UIKit

final class ATArticlesListViewController: UIViewController {

    let viewModel: ATArticlesListViewModel

    @IBOutlet weak var tableView: UITableView!

    init(viewModel vm: ATArticlesListViewModel) {
        viewModel = vm
        super.init(nibName: "ATArticlesListViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        viewModel = ATArticlesListViewModel(dataSource: ATArticlesListDataSource())
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Top Stories"
        setupTableView()
    }

    func setupTableView() {

        // infinite scrolling header
        let scrollHeader = ATSectionScrollView(frame: CGRect(x: 0, y: 0, width: Int(tableView.frame.size.width), height: ATViewDimensions.articleSectionScrollViewHeight.rawValue),
                                               viewModel: viewModel)
        tableView.tableHeaderView = scrollHeader
        tableView.register(UINib(nibName: "ATArticleListItemCell", bundle: nil),
                           forCellReuseIdentifier: ATTableCellIdentifier.articleListCell.rawValue)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150;
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ATArticlesListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ATTableCellIdentifier.articleListCell.rawValue,
                                                 for: indexPath)
        if let item = viewModel.articleItem(at: indexPath),
            let articleCell = cell as? ATArticleListItemCell {
            let itemVM = ATArticleItemViewModel(item)
            articleCell.viewModel = itemVM
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // make the highlight fade
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
