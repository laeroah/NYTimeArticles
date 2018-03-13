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

enum ErrorCode: Int {
    case httpError = 20000
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
final class ATNYTimeAPIService {

    var httpClient: ATHttpClientable
    let dateFormatter = DateFormatter()
    let decoder = JSONDecoder()

    init(httpClient client: ATHttpClientable) {
        self.httpClient = client
        self.dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.decoder.dateDecodingStrategy = .formatted(self.dateFormatter)
    }

    convenience init() {
        self.init(httpClient: ATHttpClient())
    }

    /// Fetch top stories from NY Times from the topstory api
    ///
    /// - Parameter complete: return the top stories from the api or error when it fails
    func fetchTopStories(complete: @escaping (_ topStories: [NYTimeArticleItem]?,
        _ error: APIServiceError?)->Void) {

        self.fetchNYTimeJSONFeed(from: .topStory) { (result) in
            switch result {
            case .success(let data):
                var stories: [NYTimeArticleItem]? = nil
                if let jsonData = data {
                    let result = try? self.decoder
                        .decode(NYTimeArticleResults.self, from: jsonData)
                    stories = result?.results
                }
                DispatchQueue.main.async {
                    complete(stories, nil)
                }
                break
            case .failure:
                DispatchQueue.main.async {
                    complete(nil, .requestFailed(reason: "request failed", code: ErrorCode.httpError.rawValue))
                }
            }
        }
    }

    /// Performs a get request to the NYTime API endpoint passed in
    ///
    /// - Parameters:
    ///   - apiPath: the api endpoint to make the call to
    ///   - complete: finish block. Returns error or data

    private func fetchNYTimeJSONFeed(from apiPath: TimeAPIURL,
                                     complete: @escaping (_ result: HttpRequestResult)-> Void) {
        let urlString = TimeAPIURL.fullURLString(fromPath: apiPath)
        self.httpClient.startGetRequest(withURL: urlString) { (result) in
            complete(result)
        }
    }
}

