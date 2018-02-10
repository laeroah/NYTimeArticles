//
//  ATSectionScrollView.swift
//  AaptivTime
//
//  Created by HAO WANG on 2/10/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import UIKit

class ATSectionScrollView: UIView {

    let viewModel: ATArticlesListViewModel
    let scroll: UIScrollView

    init(frame: CGRect, viewModel vm: ATArticlesListViewModel) {
        viewModel = vm
        scroll = UIScrollView(frame: .zero)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: frame)

        self.addSubview(scroll)
        self.addLayoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addLayoutConstraints() {

        // center the scrollview and make it take full height and 1/3 of the width
        NSLayoutConstraint.activate([
            scroll.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            scroll.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            scroll.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0/3.0),
            scroll.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
}
