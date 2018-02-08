//
//  ViewController.swift
//  AaptivTime
//
//  Created by HAO WANG on 2/6/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let service = ATNYTimeAPIService()
        service.fetchTopStories { (json, error) in
            if let topStories = json {
                // process top stories here
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

