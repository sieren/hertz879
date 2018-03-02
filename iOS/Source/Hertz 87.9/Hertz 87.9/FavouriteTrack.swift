//  Copyright © 2018 Hertz 87.9. All rights reserved.

import Foundation

protocol PropertyListReadable {
  func propertyListRepresentation() -> NSDictionary
  init?(propertyListRepresentation: NSDictionary?)
}

struct FavouriteTrack {
  var title: String?
  var author: String?
  var timeStamp: Date?

  init(track: XSPFTrack) {
    self.title = track.title
    self.author = track.author
    self.timeStamp = track.timeStamp
  }
}

extension FavouriteTrack: Equatable {
  static func == (lhs: FavouriteTrack, rhs: FavouriteTrack) -> Bool {
    return lhs.author == rhs.author &&
      lhs.title == rhs.title &&
      lhs.timeStamp == rhs.timeStamp
  }
}

extension FavouriteTrack: PropertyListReadable {

  init(data: NSDictionary) {
    // swiftlint:disable:next force_cast
    let representation = data as! [String: AnyObject]
    if let title = representation["title"] as? String {
      self.title = title
    }
    if let author = representation["author"] as? String {
      self.author = author
    }
    if let timeStamp = representation["timestamp"] as? Date {
      self.timeStamp = timeStamp
    }
  }

  func propertyListRepresentation() -> NSDictionary {
    var representation = [String: AnyObject]()
    if let author = self.author {
      representation["author"] = author as AnyObject
    }
    if let title = self.title {
      representation["title"] = title as AnyObject
    }
    if let timestamp = self.timeStamp {
      representation["timestamp"] = timestamp as AnyObject
    }
    return representation as NSDictionary
  }

  init?(propertyListRepresentation: NSDictionary?) {
    guard let values = propertyListRepresentation
      else {return nil}
    self =  FavouriteTrack(data: values)
  }
}

extension XSPFTrack {
  var favouriteTrack: FavouriteTrack {
    return FavouriteTrack(track: self)
  }
}
