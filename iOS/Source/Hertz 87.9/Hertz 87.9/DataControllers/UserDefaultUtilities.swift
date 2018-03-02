//  Created by Matthias Frick on 02.03.2018.

import Foundation

struct UserDefaultsUtilities {

  static func extractValuesFromPropertyListArray<T: PropertyListReadable>(propertyListArray: [AnyObject]?) -> [T] {
    guard let encodedArray = propertyListArray
      else {return []}
    return encodedArray.map { $0 as? NSDictionary}.flatMap { T(propertyListRepresentation: $0) }
  }

  static func saveValuesToDefaults<T: PropertyListReadable>(newValues: [T], key: String) {
    let encodedValues = newValues.map { $0.propertyListRepresentation() }
    UserDefaults.standard.set(encodedValues, forKey: key)
  }
}
