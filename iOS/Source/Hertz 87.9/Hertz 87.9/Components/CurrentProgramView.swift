//
//  CurrentProgramView.swift
//  Hertz 87.9
//
//  Created by Matthias Frick on 19/09/2019.
//  Copyright © 2019 Hertz 87.9. All rights reserved.
//

import SwiftUI

struct CurrentProgramView: View {
    var body: some View {
      VStack(alignment: .leading, spacing: 10) {
        Text("Aktuell").font(.title).bold()
        Text("Eine Sendung mit der Maus").font(.subheadline)
      }        
    }
}
//
//struct CurrentProgramView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrentProgramView()
//    }
//}
