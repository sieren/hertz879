//  Copyright © 2018 Hertz 87.9. All rights reserved.

import XCTest
import FeedKit
@testable import Hertz_87_9

class NewsControllerTests: XCTestCase {

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

  var newsController: NewsController!
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

    let feedController = RSSFeedController(webRequestManager: WebRequestManager(session: session))
    newsController = NewsController(feedController: feedController)
  }

  class TestDelegate: NewsControllerDelegate {
    var testExpectation: XCTestExpectation?
    func didUpdateNewsItems(error: NetRequestError?) {
      testExpectation?.fulfill()
    }
  }

  func testUpdateFunctionCalledAfterUpdate() {
    let testDelegate = TestDelegate()
    testDelegate.testExpectation = expectation(description: "Delegate Callback Called")

    newsController.delegate = testDelegate
    newsController.update()

    waitForExpectations(timeout: 1.0) { (error) in
      if error != nil {
        XCTFail(error!.localizedDescription)
      }
    }

    XCTAssertEqual(newsController.newsItems!.count, 10)
  }
}
