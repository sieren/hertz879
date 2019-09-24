//
//  PlayerView.swift
//  Hertz 87.9
//
//  Created by Matthias Frick on 19/09/2019.
//  Copyright © 2019 Hertz 87.9. All rights reserved.
//

import SwiftUI

struct PlayerView: View {
    @ObservedObject var streamController: StreamController
    @ObservedObject var playlistController: PlaylistController

    var body: some View {
      GeometryReader { geometry in
        VStack(alignment: .leading) {
          HStack(spacing: 0) {
            Button(action: {
              self.streamController.setPlay(play: !self.streamController.playState)
            })
            {
              HStack {
                Image(systemName: self.streamController.playState ? "stop.fill" :  "play.fill")
                  .font(Font.system(size: 40)).foregroundColor(.black)
              }
              .frame(minHeight: 0, maxHeight: geometry.size.height)
              .frame(minWidth: 0, maxWidth: geometry.size.height)
              .padding(0)
              .background(Color("playColor"))
            }
              .edgesIgnoringSafeArea(.leading)
            CurrentTitleView(playlistController: self.playlistController)
              .frame(minHeight: 0, maxHeight: geometry.size.height)
              .background(Color("playBgColor"))
            Button(action: {
               // none
             }) {
               HStack {
                 Image(systemName: "heart.fill")
                   .font(Font.system(size: 30)).foregroundColor(.black)
               }
               .frame(minHeight: 0, maxHeight: geometry.size.height)
               .frame(minWidth: 0, maxWidth: geometry.size.height)
               .padding(0)
               .edgesIgnoringSafeArea(.leading)
               .background(Color.pink)
             }
          }
        }
        .edgesIgnoringSafeArea(.horizontal)
        .background(Color.white)
      }
  }
}
//
//struct PlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayerView()
//    }
//}
