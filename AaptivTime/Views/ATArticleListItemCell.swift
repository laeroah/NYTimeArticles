//
//  ATArticleListItemCell.swift
//  AaptivTime
//
//  Created by HAO WANG on 2/10/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import UIKit

class ATArticleListItemCell: UITableViewCell {

    @IBOutlet weak var articleThumbnail: UIImageView!
    @IBOutlet weak var articleAbstract: UILabel!
    @IBOutlet weak var publishedDate: UILabel!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleByLine: UILabel!
    
    var viewModel: ATArticleItemViewModel? {
        didSet {
            articleThumbnail.image = nil
            if let thumbnailUrlString = viewModel?.articleItem.thumbnailUrl,
                let thumbnailUrl = URL(string: thumbnailUrlString){
                articleThumbnail.setImageURL(thumbnailUrl)
            }
            self.articleTitle.text = viewModel?.articleItem.title
            self.articleAbstract.text = viewModel?.articleItem.abstract
            self.articleByLine.text = viewModel?.articleItem.byLine
            self.publishedDate.text = viewModel?.dateLabel
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // these ugly lines are added to avoid UITableViewCell layout bug
        // refer to: https://stackoverflow.com/questions/23664212/uilabel-in-uitableviewcell-with-auto-layout-has-wrong-height
        self.contentView.layoutIfNeeded()
        self.articleTitle.preferredMaxLayoutWidth = self.articleTitle.frame.size.width
        self.articleByLine.preferredMaxLayoutWidth = self.articleByLine.frame.size.width
    }
}
