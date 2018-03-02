//  Copyright © 2018 Hertz 87.9. All rights reserved.

import Foundation
import SwiftyJSON

typealias ServiceResponse = (Data?, NetRequestError?) -> Void

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

enum NetRequestError: Error {
  case networkError
}

protocol URLSessionDataTaskProtocol {
  func resume()
}

protocol URLSessionProtocol {
  func dataTask(with url: URL,
                completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

class WebRequestManager: NSObject {

  static let sharedInstance = WebRequestManager()
  let session: URLSessionProtocol!

  init(session: URLSessionProtocol = URLSession.shared) {
    self.session = session
  }

  func makeHTTPGetRequest(url: URL, onCompletion: @escaping ServiceResponse) {
    let task = session.dataTask(with: url, completionHandler: {data, response, error -> Void in
      if error != nil {
        onCompletion(nil, NetRequestError.networkError)
      } else if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
        onCompletion(data, nil)
      } else {
        onCompletion(nil, NetRequestError.networkError)
      }
    })
    task.resume()
  }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
extension URLSession: URLSessionProtocol {

  func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
    return (dataTask(with: url, completionHandler: completionHandler)
      as URLSessionDataTask) as URLSessionDataTaskProtocol
  }
}
