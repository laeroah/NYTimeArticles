//
//  ATSectionScrollView.swift
//  AaptivTime
//
//  Created by HAO WANG on 2/10/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import UIKit

protocol ATSectionsScrollDelegate: NSObjectProtocol {
    func didSelectSection(_ section: Int)
}

class ATSectionScrollView: UIStackView {

    let viewModel: ATArticlesListViewModel
    let scroll: UIScrollView
    let leftButton: UIButton
    let rightButton: UIButton

    weak var delegate: ATSectionsScrollDelegate?

    var sectionLabels: [UILabel] = []

    var numPages: Int {
        return self.viewModel.numberOfSections()
    }

    init(frame: CGRect, viewModel vm: ATArticlesListViewModel) {
        viewModel = vm
        scroll = UIScrollView(frame: .zero)
        leftButton = UIButton(type: .custom)
        rightButton = UIButton(type: .custom)
        super.init(frame: frame)

        axis = .horizontal
        distribution = .fill
        spacing = CGFloat(ATViewDimensions.articleSectionScrollViewSpacing.rawValue)
        alignment = .center
        setupSubviews()
        addLayoutConstraints()

        // accessibility
        scroll.accessibilityIdentifier = "ArticleSectionInfiniteScroll"
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        loadInitialLabels()
    }

    func reload() {
        for label in sectionLabels {
            label.removeFromSuperview()
        }
        loadInitialLabels()
    }

    private func setupSubviews() {
        addArrangedSubview(leftButton)
        addArrangedSubview(scroll)
        addArrangedSubview(rightButton)

        scroll.delegate = self
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.isPagingEnabled = true

        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        leftButton.adjustsImageSizeForAccessibilityContentSizeCategory = true
        leftButton.setImage(UIImage(named: "left_arrow"), for: .normal)
        leftButton.contentMode = .scaleAspectFit
        
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        rightButton.adjustsImageSizeForAccessibilityContentSizeCategory = true
        rightButton.setImage(UIImage(named: "right_arrow"), for: .normal)
        rightButton.contentMode = .scaleAspectFit
    }

    private func addLayoutConstraints() {

        scroll.translatesAutoresizingMaskIntoConstraints = false
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false

        // center the scrollview and make it take full height and 1/2 of the width
        NSLayoutConstraint.activate([
            scroll.heightAnchor.constraint(equalTo: self.heightAnchor),

            leftButton.widthAnchor.constraint(equalToConstant: 40),
            leftButton.heightAnchor.constraint(equalToConstant: 40),

            rightButton.widthAnchor.constraint(equalToConstant: 40),
            rightButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    private func loadInitialLabels() {

        for i in 0..<viewModel.numberOfSections() {
            let label = UILabel()
            label.text = viewModel.sectionName(at: i)
            label.textAlignment = .center
            label.font = .articleSectionFont
            sectionLabels.append(label)
        }

        scroll.contentSize = CGSize(width: (scroll.frame.size.width * (CGFloat(numPages) + 2)), height: frame.size.height)

        loadScrollViewWithPage(0)
        loadScrollViewWithPage(1)
        loadScrollViewWithPage(2)

        scrollTo(page: 1, animated: false)
    }

    private func view(at index: Int) -> UIView? {
        return index < sectionLabels.count && index >= 0 ? sectionLabels[index] : nil
    }

    private func loadScrollViewWithPage(_ page: Int) {
        if page < 0 { return }
        if page >= numPages + 2 { return }

        var index = 0

        // page 0 displays the last label
        // page 1 displays the first label
        if page == 0 {
            index = numPages - 1
        } else if page == numPages + 1 {
            index = 0
        } else {
            index = page - 1
        }

        if let view = view(at: index) {
            var newFrame = scroll.frame
            newFrame.origin.x = scroll.frame.size.width * CGFloat(page)
            newFrame.origin.y = 0
            view.frame = newFrame

            if view.superview == nil {
                scroll.addSubview(view)
            }
        }

        scroll.layoutIfNeeded()
    }

    private func currentPage() -> Int {
        let pageWidth = scroll.frame.size.width
        let page : Int = Int(floor((scroll.contentOffset.x - (pageWidth/2)) / pageWidth) + 1)
        return page
    }

    private func scrollTo(page: Int, animated: Bool) {
        var newFrame = scroll.frame
        newFrame.origin.x = newFrame.size.width * CGFloat(page)
        newFrame.origin.y = 0
        scroll.scrollRectToVisible(newFrame, animated: animated)
    }

    ///  updates the content offset if you're at the end of the pageable content.
    private func circulateScrollIfNecessary() {
        let pageWidth = scroll.frame.size.width
        let page = currentPage()
        if page == 0 {
            scroll.contentOffset = CGPoint(x: pageWidth*(CGFloat(numPages)), y: 0)
        } else if page == numPages+1 {
            scroll.contentOffset = CGPoint(x: pageWidth, y: 0)
        }
    }
}

// MARK: control buttons
extension ATSectionScrollView {
    @objc private func leftButtonTapped() {
        let page = currentPage()
        scrollTo(page: page - 1, animated: true)
    }

    @objc private func rightButtonTapped() {
        let page = currentPage()
        scrollTo(page: page + 1, animated: true)
    }
}

extension ATSectionScrollView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let page = currentPage()
        loadScrollViewWithPage(Int(page - 1))
        loadScrollViewWithPage(Int(page))
        loadScrollViewWithPage(Int(page + 1))
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        circulateScrollIfNecessary()
        let page = currentPage()
        delegate?.didSelectSection(page - 1)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        circulateScrollIfNecessary()
        let page = currentPage()
        delegate?.didSelectSection(page - 1)
    }
}
