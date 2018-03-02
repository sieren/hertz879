//  Copyright © 2018 Hertz 87.9. All rights reserved.

import Foundation
//  Copyright © 2018 Hertz 87.9. All rights reserved.

import XCTest
@testable import Hertz_87_9

class PlaylistControllerTest: XCTestCase {

  class MockURLDataTask: URLSessionDataTaskProtocol {
    func resume() {
      // noop
    }
  }
  class MockURLSession: URLSessionProtocol {
    var nextDataTask = MockURLDataTask()
    var nextData: [Data?]! {
      didSet {
        dataIterator = nextData.makeIterator()
      }
    }
    var dataIterator: IndexingIterator<[Data?]>!
    var nextError: Error?
    var nextResponse = HTTPURLResponse(statusCode: 200)

    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
      lastURL = url
      guard let data = dataIterator.next() else { return nextDataTask }
      completionHandler(data, nextResponse, nextError)
      return nextDataTask
    }

    private (set) var lastURL: URL?
  }

  var playlistController: PlaylistController!
  var session: MockURLSession!
  var testDate: Date!

  override func setUp() {
    super.setUp()
    session = MockURLSession()
    let testBundle = Bundle(for: type(of: self))
    let fileURL = testBundle.url(forResource: "playlist", withExtension: "xspf")
    XCTAssertNotNil(fileURL)
    do {
      let data = try Data(contentsOf: fileURL!)
      session.nextData = [Data?]()
      session.nextData.append(data)
    } catch {
      XCTAssert(true, error.localizedDescription)
    }

    playlistController = PlaylistController(webRequestManager: WebRequestManager(session: session))
    let dateStr = "2018-03-01 07:30" // Monday

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    dateFormatter.timeZone = TimeZone(abbreviation: "CET")
    testDate = dateFormatter.date(from: dateStr)!
  }

  func testGetPlaylistRequestsCorrectURL() {
    let expectedUrl = URL(string: "https://stream.radiohertz.de/playlist/2018/03/01.xspf")
    playlistController.loadSongs(for: testDate)
    XCTAssertEqual(session.lastURL, expectedUrl)
  }

  func testGetPlaylistGetsTracklist() {
    playlistController.loadSongs(for: testDate)

    XCTAssertNotNil(playlistController.playlist)
    // Ensure capped to 100 Entries
    XCTAssertEqual(playlistController.playlist?.count, 100)
  }

  func testGetPlaylistSingleEntry() {
    playlistController.loadSongs(for: testDate)
    XCTAssertNotNil(playlistController.playlist)

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
    let expectedTime = dateFormatter.date(from: "2018-03-01T23:57:47+01:00")!

    let track = playlistController.playlist?.first
    XCTAssertEqual(track?.author, "Uone")
    XCTAssertEqual(track?.title, "Horsing Round")
    XCTAssertEqual(track?.timeStamp, expectedTime)
  }

  func testGetPlaylistIsSortedByNewestFirst() {
    playlistController.loadSongs(for: testDate)
    XCTAssertNotNil(playlistController.playlist)

    let firstTrack = playlistController.playlist?.first
    let lastTrack = playlistController.playlist?.last
    XCTAssertTrue(firstTrack!.timeStamp! > lastTrack!.timeStamp!)
  }
}
