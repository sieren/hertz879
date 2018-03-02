//  Copyright © 2018 Hertz 87.9. All rights reserved.

import Foundation

// Since the current Hertz JSON File is using hard coded week-days instead
// of an Array, we need to manually decode the JSON instead of using the Codable
// protocol.
// This is considered tech-debt and should be fixed.

struct ProgramEntry {
  let time: String
  let title: String
  let description: String
  var url: URL? {
    return URL(string: urlStr)
  }
  private let urlStr: String

  var startTime: Date {
    let startTime = time.components(separatedBy: " ").first!
    return convertToTime(time: startTime)
  }

  var endTime: Date {
    let startTime = time.components(separatedBy: " ").last!
    return convertToTime(time: startTime)
  }

  init?(json: [String: Any]) {
    guard let time = json["time"] as? String,
      let title = json["name"] as? String,
      let description = json["desc"] as? String,
      let url = json["url"] as? String else { return nil }

    self.time = time
    self.title = title
    self.description = description
    self.urlStr = url
  }

  private func convertToTime(time: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    dateFormatter.timeZone = TimeZone(abbreviation: "CET")
    return dateFormatter.date(from: time)!
  }
}

struct ProgramWeek {
  var programsDay: [Int: [ProgramEntry]]

  init?(json: [String: Any]) {
    self.programsDay = [Int: [ProgramEntry]]()
    for i in 1...7 {
      let dayData = json[String(i)] as? [Any]
      programsDay[i] = [ProgramEntry]()
      for dayItem in dayData! {
        let item = dayItem as? [String: Any]
        guard let entry = ProgramEntry(json: item!) else { continue }
        programsDay[i]?.append(entry)
      }
    }
  }
}

struct Fact {
  let title: String
  let description: String
  var url: URL? {
    return URL(string: urlStr)
  }
  private let urlStr: String

  init?(json: [String: Any]) {
    guard let title = json["name"] as? String,
      let description = json["desc"] as? String,
      let urlStr = json["url"] as? String else { return nil }

    self.title = title
    self.description = description
    self.urlStr = urlStr
  }
}
