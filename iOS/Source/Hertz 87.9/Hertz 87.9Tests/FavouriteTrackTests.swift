//  Copyright © 2018 Hertz 87.9. All rights reserved.

import XCTest
@testable import Hertz_87_9

class FavouriteTrackTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  func testConversionFromXSPFTrack() {
    let xspfTrack = XSPFTrack()
    let date = Date()
    xspfTrack.title = "Title"
    xspfTrack.author = "Author"
    xspfTrack.timeStamp = date

    let favTrack = FavouriteTrack(track: xspfTrack)

    XCTAssertEqual(favTrack.title, xspfTrack.title)
    XCTAssertEqual(favTrack.author, xspfTrack.author)
    XCTAssertEqual(favTrack.timeStamp, xspfTrack.timeStamp)

    XCTAssertEqual(xspfTrack.favouriteTrack, favTrack)
  }
}
