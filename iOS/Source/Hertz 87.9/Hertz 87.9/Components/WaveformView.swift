//
//  WaveformView.swift
//  Hertz 87.9
//
//  Created by Matthias Frick on 20/09/2019.
//  Copyright © 2019 Hertz 87.9. All rights reserved.
//

import UIKit
import SoundWave
import SwiftUI

struct WaveFormViewUI: View {
  @ObservedObject var streamController: StreamController

  var body: some View {
    HStack {
      WaveformView(power: streamController.currentPower)
    }
  }
}

struct WaveformView: UIViewRepresentable {
  var waveFormView = AudioVisualizationView()
  var power: CGFloat = 0

  func makeCoordinator() -> Coordinator {
      Coordinator(self)
  }

  func makeUIView(context: UIViewRepresentableContext<WaveformView>) -> UIView {
    waveFormView.gradientStartColor = .white
    waveFormView.gradientEndColor = .black
    waveFormView.audioVisualizationMode = .write
    return waveFormView
  }

  func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<WaveformView>) {
  // swiftlint:disable:next force_cast
    let view = uiView as! AudioVisualizationView
    view.add(meteringLevel: Float(power))
  }

  class Coordinator: NSObject {
      var parent: WaveformView

//    func updatePower(CGFloat: power) {
//
//    }
      init(_ waveformView: WaveformView) {
        self.parent = waveformView
        super.init()
      }

  }
}

