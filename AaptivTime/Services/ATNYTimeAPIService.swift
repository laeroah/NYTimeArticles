//
//  ATNYTimeAPIService.swift
//  AaptivTime
//
//  Created by HAO WANG on 2/7/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import Foundation
import Alamofire

enum APIServiceError: Error {
    case requestFailed(reason: String, code: Int)
    case unexpectedResponseFormat
}

fileprivate enum TimeAPIURL: String {
    // NewYorkTime api sample URL:
    // https://developer.nytimes.com/proxy/https/api.nytimes.com/svc/topstories/v2/home.json?api-key=d27564e03c3940cfa6c7a5ad293cce39
    case base = "https://api.nytimes.com/svc"
    case apiKey = "d27564e03c3940cfa6c7a5ad293cce39"
    case topStory = "/topstories/v2/home.json"

    static func fullURLString(fromPath: TimeAPIURL) -> String {
        return TimeAPIURL.base.rawValue + fromPath.rawValue + "?api-key=" + TimeAPIURL.apiKey.rawValue
    }
}

/// This is the service class for fetching data from NY Times API
final class ATNYTimeAPIService{

    var httpClient: ATHttpClientable

    init() {
        self.httpClient = ATHttpClient()
    }

    convenience init(httpClient client: ATHttpClientable) {
        self.init()
        self.httpClient = client
    }

    /// Fetch top stories from NY Times from the topstory api
    ///
    /// - Parameter complete: return the json from the api or error when it fails
    func fetchTopStories(complete: @escaping (_ json: [String: Any]?, _ error: APIServiceError?)->Void) {
        self.fetchNYTimeJSONFeed(from: .topStory) { (result, error) in

            if let json = result as? [String: Any] {
                complete(json, nil)
            } else {
                complete(nil, .unexpectedResponseFormat)
            }
        }
    }

    /// Performs a get request to the NYTime API endpoint passed in
    ///
    /// - Parameters:
    ///   - apiPath: the api endpoint to make the call to
    ///   - complete: finish block. Returns error or data
    private func fetchNYTimeJSONFeed(from apiPath: TimeAPIURL,
                                     complete: @escaping (_ result: Any?, _ error: Error?)->Void) {
        let urlString = TimeAPIURL.fullURLString(fromPath: apiPath)
        self.httpClient.startGetRequest(withURL: urlString, complete: complete)
    }
}

