//  Copyright © 2018 Hertz 87.9. All rights reserved.

import Foundation

struct Song {
  let time: Date
  let artist: String
  let title: String
}

typealias PlayListCompletionHandler = () -> Void

extension XSPFTrack {
  var timeStamp: Date? {
    guard let time = self.meta[0] as? String else { return nil }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
    return dateFormatter.date(from: time)!
  }
}

class PlaylistController {
  private static let kPlaylistLimit = 100
  var playlist: [XSPFTrack]?
  let webRequestManager: WebRequestManager!

  init(webRequestManager: WebRequestManager = WebRequestManager.sharedInstance) {
    self.webRequestManager = webRequestManager
  }

  func loadSongs(for date: Date = Date(), completionHandler: PlayListCompletionHandler? = nil) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy'/'MM'/'dd'.xspf'"
    dateFormatter.timeZone = TimeZone(abbreviation: "CET")
    let today = dateFormatter.string(from: date)
    guard let url = URL(string: RemoteURLs.defaultPlaylistURL + today) else { return }
    webRequestManager.makeHTTPGetRequest(url: url) { (data, error) in
      if error != nil { return }
      guard let responseData = data else { return }
      let tracklist = XSPFManager.sharedInstance().playlist(from: responseData)

      self.playlist = tracklist?.trackList.reverseObjectEnumerator().allObjects as? [XSPFTrack]
      guard let arraySlice = self.playlist?[0..<PlaylistController.kPlaylistLimit] else { return }
      self.playlist = Array(arraySlice)
      completionHandler?()
    }
  }
}
