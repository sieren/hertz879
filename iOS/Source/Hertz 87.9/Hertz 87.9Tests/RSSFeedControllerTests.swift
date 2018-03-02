//  Copyright © 2018 Hertz 87.9. All rights reserved.

import XCTest
import FeedKit
@testable import Hertz_87_9

class RSSFeedControllerTests: XCTestCase {

  class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    func resume() {
      resumeWasCalled = true
    }
  }

  class MockURLSession: URLSessionProtocol {
    var nextDataTask = MockURLSessionDataTask()
    var nextData: Data?
    var nextError: Error?
    var nextResponse = HTTPURLResponse(statusCode: 200)

    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
      lastURL = url
      completionHandler(nextData, nextResponse, nextError)
      return nextDataTask
    }
    private (set) var lastURL: URL?
  }

  var feedController: RSSFeedController!
  var data: Data?
  override func setUp() {
    super.setUp()
    let testBundle = Bundle(for: type(of: self))
    let fileURL = testBundle.url(forResource: "hertztestfeed", withExtension: "xml")
    let session = MockURLSession()
    XCTAssertNotNil(fileURL)
    do {
      data = try Data(contentsOf: fileURL!)
      session.nextData = data
    } catch {
      XCTAssert(true, error.localizedDescription)
    }

    feedController = RSSFeedController(webRequestManager: WebRequestManager(session: session))
  }

  func testParsingFeedDataFromURLReturnsData() {
    let testURL = URL(string: "http://does.not.matter")!
    let parseExpectation = expectation(description: "RSS URL Parsed")
    feedController.pollRSSData(for: testURL) { (result, error) in
      XCTAssertNil(error)
      XCTAssert(result!.isSuccess)
      XCTAssertNotNil(result?.rssFeed)
      XCTAssertEqual(result?.rssFeed?.items?.count, 10)
      parseExpectation.fulfill()
    }

    waitForExpectations(timeout: 1) { error in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }
    }
  }

  func testParsingFeedDataSingleItem() {
    let testURL = URL(string: "http://does.not.matter")!
    var feedItem: FeedKit.RSSFeedItem!
    let parseExpectation = expectation(description: "RSS Data Parsed")
    feedController.pollRSSData(for: testURL) { (result, error) in
      XCTAssertNil(error)
      XCTAssert(result!.isSuccess)
      XCTAssertNotNil(result?.rssFeed)
      XCTAssertEqual(result?.rssFeed?.items?.count, 10)
      feedItem = result?.rssFeed?.items![0]
      parseExpectation.fulfill()
    }

    waitForExpectations(timeout: 1) { error in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }
    }
    XCTAssertEqual(feedItem.title, "Keine Schule für 263 Millionen")
  }

}
