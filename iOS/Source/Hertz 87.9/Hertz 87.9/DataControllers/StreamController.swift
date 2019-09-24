//  Copyright © 2018 Hertz 87.9. All rights reserved.

import AVFoundation
import Combine
import SwiftUI
import Foundation

class StreamController: ObservableObject {

  let didChange = PassthroughSubject<StreamController, Never>()
  private var streamPlayer: FSAudioStream?
  private var levelsTimer: Timer?
  @Published private(set) var playState: Bool = false
  @Published private(set) var currentPower: CGFloat = 0.0

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
    streamPlayer = FSAudioStream(url: url)
    streamPlayer?.play()
    levelsTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(0.05), repeats: true, block: { (_) in
      self.currentPower = abs(self.normalizedPowerLevelFromDecibels(CGFloat(self.streamPlayer?.levels.averagePower ?? 0.0)))
    })
  }

  func stop() {
    streamPlayer?.pause()
    streamPlayer = nil
  }

  func normalizedPowerLevelFromDecibels(_ decibels: CGFloat) -> CGFloat {
    if decibels < -60.0 || decibels == 0.0 {
      return 0.0
    }

    return CGFloat(powf((powf(10.0, Float(0.05 * decibels))
      - powf(10.0, 0.05 * -60.0))
      * (1.0 / (1.0 - powf(10.0, 0.05 * -60.0))), 1.0 / 2.0));
  }
}
