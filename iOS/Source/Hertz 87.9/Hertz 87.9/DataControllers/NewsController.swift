//  Copyright © 2018 Hertz 87.9. All rights reserved.

import Foundation
import FeedKit

protocol NewsControllerDelegate: class {
  func didUpdateNewsItems(error: NetRequestError?)
}

class NewsController {

  private let feedController: RSSFeedController!
  var newsItems: [FeedKit.RSSFeedItem]?
  weak var delegate: NewsControllerDelegate?

  init(feedController: RSSFeedController = RSSFeedController()) {
    self.feedController = feedController
  }

  func update() {
    self.feedController.pollRSSData(for: URL(string: RemoteURLs.defaultRSSNewsFeedURL)!) { (result, error) in
      self.newsItems = result?.rssFeed?.items
      DispatchQueue.main.async {
        self.delegate?.didUpdateNewsItems(error: error)
      }
    }
  }
}
