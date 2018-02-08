//
//  ATHttpClient.swift
//  AaptivTime
//
//  Created by HAO WANG on 2/7/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import Foundation
import Alamofire

class ATHttpClient: ATHttpClientable {

    func startGetRequest(withURL url: String, complete: @escaping (_ value: Any?, _ error: Error?) -> ()) {
        Alamofire.request(url).responseJSON { (response) in
            let result = response.result
            switch result {
            case let .success(value):
                complete(value, nil)
                break
            case let .failure(error):
                // should log the error somewhere like rollbar
                complete(nil, error)
                break
            }
        }
    }
}
