//  Copyright © 2018 Hertz 87.9. All rights reserved.

import Foundation

protocol FavouriteTracksDelegate: class {
  func songsUpdated()
}

class FavouriteTracksController {
  public static let kSongKey = "FavouriteSongs"
  var songs: [FavouriteTrack]!
  weak var delegate: FavouriteTracksDelegate?

  init() {
    if let data = UserDefaults.standard.object(
      forKey: FavouriteTracksController.kSongKey) as? [AnyObject] {
      let decodedSongs: [FavouriteTrack] = UserDefaultsUtilities.extractValuesFromPropertyListArray(
        propertyListArray: data)
      self.songs = decodedSongs
    } else {
      self.songs = [FavouriteTrack]()
    }
  }

  func addTrack(track: XSPFTrack) {
    let encodableTrack = FavouriteTrack(track: track)
    songs.insert(encodableTrack, at: 0)
    delegate?.songsUpdated()
    save()
  }

  func deleteTrack(at index: Int) {
    songs.remove(at: index)
    delegate?.songsUpdated()
    save()
  }

  func deleteAll() {
    songs.removeAll()
    delegate?.songsUpdated()
    save()
  }

  private func save() {
    UserDefaultsUtilities.saveValuesToDefaults(newValues: songs, key: FavouriteTracksController.kSongKey)
    UserDefaults.standard.synchronize()
  }
}
