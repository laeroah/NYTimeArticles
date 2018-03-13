//
//  ATHttpClient.swift
//  AaptivTime
//
//  Created by HAO WANG on 2/7/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import Foundation

class ATHttpClient: ATHttpClientable {

    let sharedSession = URLSession(configuration: .default)

    func startGetRequest(withURL urlString: String, complete: @escaping (_ result: HttpRequestResult) -> Void) {

        guard let url = URL(string: urlString) else {
            return
        }
        let task = sharedSession.dataTask(with: url) { (data, response, error) in

            if error == nil {
                complete(.success(data))
            } else {
                complete(.failure(error))
            }
        }
        task.resume()
    }

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
