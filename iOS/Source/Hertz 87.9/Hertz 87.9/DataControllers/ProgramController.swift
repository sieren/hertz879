//  Copyright © 2018 Hertz 87.9. All rights reserved.

import Foundation

typealias ProgramResponse = (ProgramError?) -> Void

public enum ProgramError: Error {
  case parseError
  case otherError(Error)
}

class ProgramController {

  public var week: ProgramWeek!
  public var facts: [Fact]!

  func getProgram(for time: Date) -> ProgramEntry? {
    let dayOfWeek = time.dayOfWeek
    let dayEntries = week.programsDay[dayOfWeek]!
    if let i = dayEntries.index(where: {
      ($0.startTime.compareTimeOnly(to: time) == .orderedAscending) &&
        ($0.endTime.compareTimeOnly(to: time) == .orderedDescending) ||
        ($0.startTime.compareTimeOnly(to: time) == .orderedSame) ||
        ($0.endTime.compareTimeOnly(to: time) == .orderedSame)
    }) {
      return dayEntries[i]
    }
    return nil
  }

  func getPrograms(callback: ProgramResponse? = nil) {
    let requestManager = WebRequestManager.sharedInstance
    requestManager.makeHTTPGetRequest(url: URL(string: RemoteURLs.defaultProgramURL)!) { (data, _) in
      self.parseJSON(jsonData: data, callback: callback)
    }
  }

  func parseJSON(jsonData: Data?, callback: ProgramResponse? = nil) {
    guard let data = jsonData else {  callback?(.parseError); return }
    guard let todoJSON = try? JSONSerialization.jsonObject(with: data,
                                                           options: []) as? [String: Any] else { return }
    self.week = ProgramWeek(json: todoJSON!)
    self.facts = getFacts(json: todoJSON!)
    callback?(nil)
  }

  func getFacts(json: [String: Any]) -> [Fact]? {
    let factJson = json["facts"] as? [Any]
    var facts = [Fact]()
    for fact in factJson! {
      guard let factItem = fact as? [String: Any], let item = Fact(json: factItem) else { continue }
      facts.append(item)
    }
    return facts
  }
}

extension ProgramError: Equatable {
  public static func == (lhs: ProgramError, rhs: ProgramError) -> Bool {
    switch (lhs, rhs) {
    case (.parseError, .parseError):
      return true

    case (.otherError, .otherError):
      return true

    default:
      return false
    }
  }
}

extension Date {
  var mondaysDate: Date {
    let iso8601 =  Calendar(identifier: .iso8601)
    return iso8601.date(from: iso8601.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
  }

  var dayOfWeek: Int {
    let cal = Calendar(identifier: .iso8601)
    let weekday = cal.dateComponents([.weekday], from: self).weekday! - 1
    // Workaround because in Hertz JSON File Monday is 1, whereas in Gregorian Sunday is 1
    return weekday == 0 ? 7 : weekday
  }
}

extension Date {
  // swiftline:disable:next identifier_name
  func compareTimeOnly(to date: Date) -> ComparisonResult {
    let calendar = Calendar.current
    let components2 = calendar.dateComponents([.hour, .minute, .second], from: date)
    let date3 = calendar.date(bySettingHour: components2.hour!, minute: components2.minute!,
                              second: components2.second!, of: self)!

    let seconds = calendar.dateComponents([.second], from: self, to: date3).second!
    if seconds == 0 {
      return .orderedSame
    } else if seconds > 0 {
      // Ascending means before
      return .orderedAscending
    } else {
      // Descending means after
      return .orderedDescending
    }
  }
}
