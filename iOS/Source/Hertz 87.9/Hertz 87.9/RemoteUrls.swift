//  Copyright © 2018 Hertz 87.9. All rights reserved.

import Foundation

struct RemoteURLs {

  private static var defaultHQStreamURL = "https://stream.radiohertz.de/hertz-hq.mp3.m3u"
  private static var defaultLQStreamURL = "https://stream.radiohertz.de/hertz-lq.mp3.m3u"
  public static var defaultProgramURL = "https://www.radiohertz.de/appdata/hertz.json"
  public static var defaultPlaylistURL = "https://stream.radiohertz.de/playlist/"
  public static let defaultCurrentArtistURL = "http://stream.radiohertz.de/playlist/current.title"
  public static let defaultCurrentTitleURL = "http://stream.radiohertz.de/playlist/current.artist"

  public struct Streams {

    // swiftlint:disable:next nesting
    enum Quality: String {
      case hqStream = "HQ"
      case lqStream = "LQ"
    }

    static func streamUrl(for quality: Quality) -> URL {
      switch quality {
      case .hqStream:
        return URL(string: defaultHQStreamURL)!
      case .lqStream:
        return URL(string: defaultLQStreamURL)!
      }
    }
  }
}
