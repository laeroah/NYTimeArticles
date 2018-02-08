//
//  ATHttpClientable.swift
//  AaptivTime
//
//  Created by HAO WANG on 2/7/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import Foundation

protocol ATHttpClientable {

    func startGetRequest(withURL url: String, complete: @escaping (_ value: Any?, _ error: Error?) -> ())
}
