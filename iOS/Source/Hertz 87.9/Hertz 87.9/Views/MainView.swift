//
//  MainView.swift
//  Hertz 87.9
//
//  Created by Matthias Frick on 15/09/2019.
//  Copyright © 2019 Hertz 87.9. All rights reserved.
//

import SwiftUI
import Combine

struct MainView: View {
    @EnvironmentObject var appContext: AppContext

    init() {
      UITabBar.appearance().backgroundColor = UIColor.init(named: "bgColor")
    }

    var body: some View {
      
        VStack/*(alignment: .leading, spacing: 0)*/ {
          ZStack{
            Color.black.edgesIgnoringSafeArea(.top)
            WaveFormViewUI(streamController: appContext.streamController)
//            CurrentProgramView()
//              .padding()
//              .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
//              .background(Color.black)
          }

          Divider()

          CurrentTitleView(playlistController: self.appContext.playlistController).padding()
          Spacer()
          PlayerView(streamController: self.appContext.streamController,
                     playlistController: self.appContext.playlistController)
            .frame(minHeight: 0, maxHeight: 50)
            .edgesIgnoringSafeArea(.bottom)
          }
//        .navigationBarTitle("")
 //       .navigationBarHidden(true)
        .navigationBarItems(leading:
          Image("hertzlogo")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(height: 40, alignment: .center))
      }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
