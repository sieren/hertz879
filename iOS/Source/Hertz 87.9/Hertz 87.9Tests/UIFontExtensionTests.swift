//  Copyright © 2018 Hertz 87.9. All rights reserved.

import XCTest
import FeedKit
@testable import Hertz_87_9

class UIFontExtensionTests: XCTestCase {

  func testReturnsExistingFonts() {
    let lightFont = UIFont.defaultLightFont(size: 12)
    let regularFont = UIFont.defaultFont(size: 12)
    let boldFont = UIFont.defaultBoldFont(size: 12)

    XCTAssertEqual(lightFont.fontName, "RobotoCondensed-Light")
    XCTAssertEqual(regularFont.fontName, "RobotoCondensed-Regular")
    XCTAssertEqual(boldFont.fontName, "RobotoCondensed-Bold")
  }
}
