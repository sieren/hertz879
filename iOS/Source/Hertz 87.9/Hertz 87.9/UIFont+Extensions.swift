//  Copyright © 2018 Hertz 87.9. All rights reserved.

import Foundation
import UIKit

private let hertzDefaultFontDescriptor = UIFontDescriptor(
  fontAttributes: [UIFontDescriptor.AttributeName.name: "RobotoCondensed-Regular"])
private let hertzBoldFontDescriptor = UIFontDescriptor(
  fontAttributes: [UIFontDescriptor.AttributeName.name: "RobotoCondensed-Bold"])
private let hertzLightFontDescriptor = UIFontDescriptor(
  fontAttributes: [UIFontDescriptor.AttributeName.name: "RobotoCondensed-Light"])

extension UIFont {
  static func defaultFont(size: CGFloat) -> UIFont {
    return UIFont(descriptor: hertzDefaultFontDescriptor, size: size)
  }

  static func defaultBoldFont(size: CGFloat) -> UIFont {
    return UIFont(descriptor: hertzBoldFontDescriptor, size: size)
  }

  static func defaultLightFont(size: CGFloat) -> UIFont {
    return UIFont(descriptor: hertzLightFontDescriptor, size: size)
  }
}
