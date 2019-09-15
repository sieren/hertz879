//
//  ContentView.swift
//  testasd
//
//  Created by Matthias Frick on 15/09/2019.
//  Copyright © 2019 Matthias Frick. All rights reserved.
//

import SwiftUI

struct NavigationView: View {
    @State private var selection = 0
    @EnvironmentObject var appContext: AppContext

    var body: some View {
        TabView(selection: $selection) {
            MainView()
                .tag(0)
            Text("Second View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("second")
                        Text("Second")
                    }
                }
                .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView()
    }
}
