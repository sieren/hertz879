//  Copyright © 2018 Hertz 87.9. All rights reserved.

import Foundation

class AppContext: ObservableObject {
  @Published public var streamController: StreamController!
  public var programController: ProgramController!

  init() {
    streamController = StreamController()
    programController = ProgramController()
  }
}
