//  Copyright © 2018 Hertz 87.9. All rights reserved.

import XCTest
@testable import Hertz_87_9

class FavouriteSongsControllerTests: XCTestCase {

  var favSongsController: FavouriteTracksController!

  override func setUp() {
    super.setUp()
    // Reset User Defaults
    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    UserDefaults.standard.synchronize()
    favSongsController = FavouriteTracksController()
  }

  func testNewControllerReturnsNotNilList() {
    XCTAssertNotNil(favSongsController.songs)
  }

  func testAddSongs() {
    let trackOne = XSPFTrack()
    trackOne.author = "Test One"
    let trackTwo = XSPFTrack()
    trackTwo.author = "Test Two"

    favSongsController.addTrack(track: trackOne)
    favSongsController.addTrack(track: trackTwo)

    XCTAssertEqual(favSongsController.songs.count, 2)
    XCTAssertEqual(favSongsController.songs[0], trackTwo.favouriteTrack)
    XCTAssertEqual(favSongsController.songs[1], trackOne.favouriteTrack)
  }

  func testPersistence() {
    let trackOne = XSPFTrack()
    trackOne.author = "Test One"
    let trackTwo = XSPFTrack()
    trackTwo.author = "Test Two"

    favSongsController.addTrack(track: trackOne)
    favSongsController.addTrack(track: trackTwo)
    XCTAssertEqual(favSongsController.songs.count, 2)

    // Reset the controller
    favSongsController = FavouriteTracksController()
    XCTAssertEqual(favSongsController.songs.count, 2)
    XCTAssertEqual(favSongsController.songs[0], trackTwo.favouriteTrack)
    XCTAssertEqual(favSongsController.songs[1], trackOne.favouriteTrack)
  }
}
