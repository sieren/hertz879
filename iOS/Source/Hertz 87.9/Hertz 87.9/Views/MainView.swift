//
//  MainView.swift
//  Hertz 87.9
//
//  Created by Matthias Frick on 15/09/2019.
//  Copyright © 2019 Hertz 87.9. All rights reserved.
//

import SwiftUI
import Combine

struct PlayerButtonView: View {
  @ObservedObject var streamController: StreamController

  var body: some View {
    HStack(alignment: .center) {
      Button(action: {
        self.streamController.setPlay(play: !self.streamController.playState)
      }) {
        return Image(systemName: self.streamController.playState ? "stop.circle" :  "play.circle")
          .font(Font.system(size: 145)).foregroundColor(.black)
      }
    }
  }
}
struct MainView: View {
    @EnvironmentObject var appContext: AppContext
    var body: some View {
      GeometryReader { geometry in
        VStack {
            Image("hertzlogo")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: geometry.size.width, height: 40, alignment: .center)
            Spacer().frame(width: geometry.size.width, height: 50, alignment: .top)
          PlayerButtonView(streamController: self.appContext.streamController)
          Spacer()
          }
      .padding()
      }
      }

}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
