//  Copyright © 2018 Hertz 87.9. All rights reserved.

import AVFoundation
import Foundation

class StreamController {

  private var streamPlayer: AVPlayer?

  init() {
    streamPlayer = AVPlayer()
  }

  func play(stream: RemoteURLs.Streams.Quality) {
    let url = RemoteURLs.Streams.streamUrl(for: stream)

    streamPlayer = AVPlayer(url: url)
    streamPlayer?.play()
  }

  func stop() {
    streamPlayer?.pause()
    streamPlayer = nil
  }
}
