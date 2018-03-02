//  Copyright © 2018 Hertz 87.9. All rights reserved.

import Foundation
import FeedKit

typealias PollRSSHandler = (FeedKit.Result?, NetRequestError?) -> Void

class RSSFeedController {

  var webRequestManager: WebRequestManager!

  init(webRequestManager: WebRequestManager = WebRequestManager.sharedInstance) {
    self.webRequestManager = webRequestManager
  }

  func pollRSSData(for url: URL, onCompletion: PollRSSHandler? = nil) {
    webRequestManager.makeHTTPGetRequest(url: url) { (fetchData, error) in
      guard let data = fetchData else { onCompletion?(nil, error); return }
      self.parseFeedData(data: data, error: error, onCompletion: onCompletion)
    }
  }

  private func parseFeedData(data: Data, error: NetRequestError?, onCompletion: PollRSSHandler? = nil) {
    let parser = FeedParser(data: data)
    parser?.parseAsync(result: { (result) in
      onCompletion?(result, nil)
    })
  }
}
