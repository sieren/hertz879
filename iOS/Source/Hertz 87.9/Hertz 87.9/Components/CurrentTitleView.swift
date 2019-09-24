//
//  CurrentTitleView.swift
//  Hertz 87.9
//
//  Created by Matthias Frick on 19/09/2019.
//  Copyright © 2019 Hertz 87.9. All rights reserved.
//

import SwiftUI
import Combine

struct CurrentTitleView: View {
  @ObservedObject var playlistController: PlaylistController

  var body: some View {
    VStack(spacing: 5) {
      Text("\(playlistController.currentSong.artist)")
        .font(.system(size: 12))
        .bold()
        .padding(-2)
        .frame(minWidth: 0, maxWidth: .infinity)
      Text("\(playlistController.currentSong.title)")
        .font(.system(size: 12))
        .padding(-2)
        .frame(minWidth: 0, maxWidth: .infinity)
    }
      .frame(minWidth: 0, maxWidth: .infinity)
  }
}

//struct CurrentTitleView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrentTitleView()
//    }
//}
