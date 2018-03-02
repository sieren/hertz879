//  Copyright © 2018 Hertz 87.9. All rights reserved.

import XCTest
@testable import Hertz_87_9

class WebRequestTests: XCTestCase {

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
    var nextResponse: HTTPURLResponse?

    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
      lastURL = url
      completionHandler(nextData, nextResponse, nextError)
      return nextDataTask
    }

    private (set) var lastURL: URL?

  }

  var webRequestManager: WebRequestManager!
  let session = MockURLSession()
  let url = URL(string: RemoteURLs.defaultProgramURL)!

  override func setUp() {
    super.setUp()
    webRequestManager = WebRequestManager(session: session)
  }

  func testGetURL() {
    session.nextResponse = HTTPURLResponse(statusCode: 200)
    webRequestManager.makeHTTPGetRequest(url: url) { (_, error) in
      XCTAssertNil(error)
    }

    XCTAssertEqual(session.lastURL, url)
  }

  func testGetStartsRequest() {
    session.nextResponse = HTTPURLResponse(statusCode: 200)
    let dataTask = MockURLSessionDataTask()
    session.nextDataTask = dataTask

    webRequestManager.makeHTTPGetRequest(url: url) { (_, error) in
      XCTAssertNil(error)
    }

    XCTAssertTrue(session.nextDataTask.resumeWasCalled)
  }

  func testGetReturnsData() {
    session.nextResponse = HTTPURLResponse(statusCode: 200)
    let expectedData = "{}".data(using: .utf8)
    session.nextData = expectedData

    var actualData: Data?
    webRequestManager.makeHTTPGetRequest(url: url) { (data, error) in
      XCTAssertNil(error)
      actualData = data
    }

    XCTAssertEqual(actualData, expectedData)
  }

  func testGetWithNetworkErrorReturnsError() {
    session.nextResponse = HTTPURLResponse(statusCode: 200)
    session.nextError = NSError(domain: "error", code: 0, userInfo: nil)

    webRequestManager.makeHTTPGetRequest(url: url) { (_, error) in
      XCTAssertNotNil(error)
    }
  }

  func testGetWithStatusCodeLower200ReturnsError() {
    session.nextResponse = HTTPURLResponse(statusCode: 199)
    var expectedError: NetRequestError?
    webRequestManager.makeHTTPGetRequest(url: url) { (_, error) in
      expectedError = error
    }
    XCTAssertEqual(expectedError, NetRequestError.networkError)
  }

  func testGetWithStatusCodeGreater299ReturnsError() {
    session.nextResponse = HTTPURLResponse(statusCode: 300)
    var expectedError: NetRequestError?
    webRequestManager.makeHTTPGetRequest(url: url) { (_, error) in
      expectedError = error
    }
    XCTAssertEqual(expectedError, NetRequestError.networkError)
  }
}

extension HTTPURLResponse {
  convenience init?(statusCode: Int) {
    self.init(url: URL(string: "http://www.radiohertz.de")!, statusCode: statusCode,
         httpVersion: nil, headerFields: nil)
  }
}
