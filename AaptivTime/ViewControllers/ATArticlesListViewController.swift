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
    var sectionScroll: ATSectionScrollView?

    @IBOutlet weak var tableView: UITableView!

    init(viewModel vm: ATArticlesListViewModel) {
        viewModel = vm
        viewModel.fetchLatestTopStories()
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
        setupViewModelBinding()
    }

    /// bind the datamodel fields with the views
    func setupViewModelBinding() {
        viewModel.currentSelectedSection.bind { [weak self] (section) in
            // current article section selection has changed
            self?.tableView.reloadData()
        }
        viewModel.contentWillChange = { [weak self] in
            self?.tableView.beginUpdates()
        }
        viewModel.contentDidChange = { [weak self] in
            self?.tableView.endUpdates()
        }
        viewModel.sectionDidInsert = { [weak self] (_, _) in
            self?.sectionScroll?.reload()
            self?.tableView.reloadData()
        }
        viewModel.sectionDidDelete = { [weak self] (_, _) in
            self?.sectionScroll?.reload()
            self?.tableView.reloadData()
        }
        viewModel.articleDidInsert = { [weak self] (item, row) in
            self?.tableView.insertRows(at: [IndexPath(row: row, section: 0)],
                                       with: .fade)
        }
        viewModel.articleDidDelete = { [weak self] (item, row) in
            self?.tableView.deleteRows(at: [IndexPath(row: row, section: 0)],
                                       with: .fade)
        }
        viewModel.articleDidUpdate = { [weak self] (item, row) in
            self?.tableView.reloadRows(at: [IndexPath(row: row, section: 0)],
                                       with: .fade)
        }
        viewModel.articleDidMove = { [weak self] (item, from, to) in
            self?.tableView.moveRow(at: IndexPath(row: from, section: 0),
                                    to: IndexPath(row: to, section: 0))
        }
    }

    func setupTableView() {

        // infinite scrolling header
        let scrollHeader = ATSectionScrollView(frame: CGRect(x: 0, y: 0, width: Int(tableView.frame.size.width), height: ATViewDimensions.articleSectionScrollViewHeight.rawValue),
                                               viewModel: viewModel)
        scrollHeader.delegate = self
        sectionScroll = scrollHeader
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

extension ATArticlesListViewController: ATSectionsScrollDelegate {
    func didSelectSection(_ section: Int) {
        viewModel.updateSelectedSection(section)
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
        if let item = viewModel.articleItem(at: indexPath) {
            AppDelegate.sharedDelegate?.appFlowCoordinator.showArticleWeb(withArticle: item)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if let item = viewModel.articleItem(at: indexPath) {
            let itemVM = ATArticleItemViewModel(item)
            let title = item.saved ? "Unsave" : "Save"
            let save = UITableViewRowAction(style: .normal, title: title) { [weak self] action, index in

                itemVM.dataSource = self?.viewModel.dataSource
                item.saved ?
                    itemVM.unsaveButtonPress() :
                    itemVM.saveButtonPress()
            }
            save.backgroundColor = item.saved ?
                UIColor.init(named: "unsaveButtonColor") :
                UIColor.init(named: "saveButtonColor")
            return [save]
        }
        
        return nil
    }
}
