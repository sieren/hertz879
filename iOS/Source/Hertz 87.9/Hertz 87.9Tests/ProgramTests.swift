//  Copyright © 2018 Hertz 87.9. All rights reserved.

import XCTest
@testable import Hertz_87_9

class ProgramTests: XCTestCase {

  var jsonData: Data!
  var programController: ProgramController!

  override func setUp() {
    super.setUp()
    programController = ProgramController()
    let testBundle = Bundle(for: type(of: self))
    let fileURL = testBundle.url(forResource: "hertz", withExtension: "json")
    XCTAssertNotNil(fileURL)
    do {
    jsonData = try Data(contentsOf: fileURL!)
    } catch {
      XCTAssert(true, error.localizedDescription)
    }
  }

  func testJsonParser() {
    XCTAssertNil(programController.week)

    let parseExpectation = expectation(description: "JSON Parsed")
    programController.parseJSON(jsonData: jsonData) { _ in
      parseExpectation.fulfill()
    }

    waitForExpectations(timeout: 1.0) { (error) in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }
    }

    XCTAssertNotNil(programController.week)
    XCTAssertEqual(programController.week.programsDay.count, 7)
  }

  func testJsonParserFailsWithError() {
    let randomData = "Bla;Bla"

    XCTAssertNil(programController.week)

    programController.parseJSON(jsonData: Data(base64Encoded: randomData)) { error in
      guard let isError = error else { XCTFail("Should contain Error message"); return }
      XCTAssertEqual(isError, ProgramError.parseError)
    }

    XCTAssertNil(programController.week)
  }

  func testProgramEntry() {
    getProgramData()

    let programEntry = programController.week.programsDay[1]![0]
    let expectedStart = convertStringToDate(time: "07:30")
    let expectedEnd = convertStringToDate(time: "08:30")
    XCTAssertEqual(programEntry.title, "TestName")
    XCTAssertEqual(programEntry.description, "TestDescription")
    XCTAssertEqual(programEntry.url, URL(string: "http://www.hertz879.de/"))
    XCTAssertEqual(programEntry.startTime, expectedStart)
    XCTAssertEqual(programEntry.endTime, expectedEnd)
  }

  func testGetProgramForDate() {
    getProgramData()
    let dateStr = "2018-01-29 07:30" // Monday

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    dateFormatter.timeZone = TimeZone(abbreviation: "CET")
    let date = dateFormatter.date(from: dateStr)!

    let expectedStart = convertStringToDate(time: "07:30")
    let expectedEnd = convertStringToDate(time: "08:30")
    let programEntry = programController.getProgram(for: date)
    XCTAssertNotNil(programEntry)
    XCTAssertEqual(programEntry?.title, "TestName")
    XCTAssertEqual(programEntry?.description, "TestDescription")
    XCTAssertEqual(programEntry?.url, URL(string: "http://www.hertz879.de/"))
    XCTAssertEqual(programEntry?.startTime, expectedStart)
    XCTAssertEqual(programEntry?.endTime, expectedEnd)
  }

  func testFacts() {
    getProgramData()
    let expectedTitle = "TestFact"
    let expectedDesc = "TestFactDesc"
    let expectedUrl = URL(string: "http://www.testurl.url")!

    XCTAssertEqual(programController.facts.count, 41)

    let testFact = programController.facts[0]
    XCTAssertEqual(testFact.title, expectedTitle)
    XCTAssertEqual(testFact.description, expectedDesc)
    XCTAssertEqual(testFact.url, expectedUrl)
  }

// MARK: Helpers

  private func convertStringToDate(time: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    dateFormatter.timeZone = TimeZone(abbreviation: "CET")
    return dateFormatter.date(from: time)!
  }

  private func getProgramData() {
    let parseExpectation = expectation(description: "JSON Parsed")
    programController.parseJSON(jsonData: jsonData) { _ in
      parseExpectation.fulfill()
    }

    waitForExpectations(timeout: 1.0) { (error) in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }
    }
  }
}
