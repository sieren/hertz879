//  Copyright © 2018 Hertz 87.9. All rights reserved.

import Foundation

struct CurrentSong: Equatable {
  let artist: String
  let title: String

  static func == (lhs: CurrentSong, rhs: CurrentSong) -> Bool {
    return lhs.artist == rhs.artist &&
      lhs.title == rhs.title
  }

}

typealias PlayListCompletionHandler = () -> Void
typealias CurrentTitleCompletionHandler = (CurrentSong?, Error?) -> Void

extension XSPFTrack {
  var timeStamp: Date? {
    get {
      if self.meta.count == 0 { return nil }
      guard let time = self.meta[0] as? String else { return nil }
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
      return dateFormatter.date(from: time)!
    }
    set {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
      let dateString = newValue != nil ? dateFormatter.string(from: newValue!) : ""
      self.meta[0] = dateString
    }
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

  func loadCurrentTitle(completionHandler: @escaping CurrentTitleCompletionHandler) {
    let titleUrl = URL(string: RemoteURLs.defaultCurrentTitleURL)!
    let artistUrl = URL(string: RemoteURLs.defaultCurrentArtistURL)!
    webRequestManager.makeHTTPGetRequest(url: artistUrl) { (data, error) in
      if error != nil { return }
      guard let responseData = data else { return completionHandler(nil, error) }
      guard let artist = String(data: responseData, encoding: .utf8) else { return }
      self.webRequestManager.makeHTTPGetRequest(url: titleUrl, onCompletion: { (data, error) in
        if error != nil { return }
        guard let responseData = data else { return completionHandler(nil, error) }
        guard let title = String(data: responseData, encoding: .utf8) else { return completionHandler(nil, error) }
        completionHandler(CurrentSong(artist: artist, title: title), error)
      })
    }
  }
}
