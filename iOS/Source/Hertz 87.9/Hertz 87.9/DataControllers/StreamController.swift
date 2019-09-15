//  Copyright © 2018 Hertz 87.9. All rights reserved.

import AVFoundation
import Combine
import SwiftUI
import Foundation

class StreamController: ObservableObject {

  let didChange = PassthroughSubject<StreamController, Never>()
  private var streamPlayer: AVPlayer?
  @Published private(set) var playState: Bool = false

  init() {
    streamPlayer = AVPlayer()
  }

  func setPlay(play: Bool) {
    if play {
      self.play(stream: .hqStream)
      playState = true
    } else {
      stop()
      playState = false
    }
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
