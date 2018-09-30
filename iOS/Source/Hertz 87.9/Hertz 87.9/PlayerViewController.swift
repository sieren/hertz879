//
//  FirstViewController.swift
//  Hertz 87.9
//
//  Created by Matthias Frick on 01.03.2018.
//  Copyright © 2018 Hertz 87.9. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
	@IBOutlet weak var musicArtist: UILabel!
	@IBOutlet weak var musicTitle: UILabel!
	private let playlistController = PlaylistController()

  override func viewDidLoad() {
    super.viewDidLoad()
    playlistController.loadCurrentTitle { (currentSong, error) in
      if error != nil { return }
      DispatchQueue.main.async {
        self.musicArtist.text = currentSong?.artist
        self.musicTitle.text = currentSong?.title
      }
    }
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
