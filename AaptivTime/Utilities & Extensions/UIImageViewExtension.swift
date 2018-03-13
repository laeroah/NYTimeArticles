//
//  UIImageViewExtension.swift
//  AaptivTime
//
//  Created by HAO WANG on 3/13/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import UIKit

extension UIImageView {

    func setImageURL(_ url: URL) {
        self.image = nil
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            if error != nil {
                self?.image = nil
            } else {
                DispatchQueue.main.async {
                    self?.image = UIImage(data: data!)
                }
            }
        }.resume()
    }
}
