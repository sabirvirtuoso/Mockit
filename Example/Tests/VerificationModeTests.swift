//
//  Mockit
//
//  Copyright (c) 2016 Syed Sabir Salman-Al-Musawi <sabirvirtuoso@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import XCTest
import Mockit


// MARK:- A test implementation of `MockFailer` protocol


class TestFailer: MockFailer {

  var message: String?
  var file: String?
  var line: Int?

  func doFail(_ message: String, file: String, line: Int) {
    self.message = message
    self.file = file
    self.line = line
  }

}


// MARK:- Tests cases for `VerificationMode` protocol


class VerificationModeTests: XCTestCase {

  var mockFailer: TestFailer!

  override func setUp() {
    mockFailer = TestFailer()
  }

  fileprivate func dummyVerificationData(timesInvoked times: Int, calledOnly: Bool = false) -> VerificationData {
    return VerificationData(build: {
      $0.functionName = "testFunction"
      $0.timesInvoked = times
      $0.calledOnly = calledOnly
      $0.file = "thisFile"
      $0.line = 1
    })
  }

}


// MARK:- Test cases for custom verification mode `Once`


extension VerificationModeTests {

  func testVerificationModeOnceFailsWhenMethodIsCalledLessThanOnce() {
    // Given
    let verificationData = dummyVerificationData(timesInvoked: 0)
    let sut = Once()

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    // When
    sut.verify(verificationData, mockFailer: mockFailer)

    // Then
    XCTAssertEqual(mockFailer.message, String(format: StringConstants.FailureMessages.verificationModeOnce,
      verificationData.functionName, verificationData.timesInvoked))
    XCTAssertEqual(mockFailer.file, "thisFile")
    XCTAssertEqual(mockFailer.line, 1)
  }

  func testVerificationModeOnceSucceedsWhenMethodIsCalledOnce() {
    // Given
    let verificationData = dummyVerificationData(timesInvoked: 1)
    let sut = Once()

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    // When
    sut.verify(verificationData, mockFailer: mockFailer)

    // Then
    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)
  }

  func testVerificationModeOnceFailsWhenMethodIsCalledMoreThanOnce() {
    // Given
    let verificationData = dummyVerificationData(timesInvoked: 3)
    let sut = Once()

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    // When
    sut.verify(verificationData, mockFailer: mockFailer)

    // Then
    XCTAssertEqual(mockFailer.message, String(format: StringConstants.FailureMessages.verificationModeOnce,
      verificationData.functionName, verificationData.timesInvoked))
    XCTAssertEqual(mockFailer.file, "thisFile")
    XCTAssertEqual(mockFailer.line, 1)
  }

}


// MARK:- Test cases for custom verification mode `AtLeastOnce`


extension VerificationModeTests {

  func testVerificationModeAtLeastOnceFailsWhenMethodIsCalledLessThanOnce() {
    // Given
    let verificationData = dummyVerificationData(timesInvoked: 0)
    let sut = AtLeastOnce()

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    // When
    sut.verify(verificationData, mockFailer: mockFailer)

    // Then
    XCTAssertEqual(mockFailer.message, String(format: StringConstants.FailureMessages.verificationModeAtLeastOnce,
      verificationData.functionName, verificationData.timesInvoked))
    XCTAssertEqual(mockFailer.file, "thisFile")
    XCTAssertEqual(mockFailer.line, 1)
  }

  func testVerificationModeAtLeastOnceSucceedsWhenMethodIsCalledOnce() {
    // Given
    let verificationData = dummyVerificationData(timesInvoked: 1)
    let sut = AtLeastOnce()

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    // When
    sut.verify(verificationData, mockFailer: mockFailer)

    // Then
    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)
  }

  func testVerificationModeAtLeastOnceSucceedsWhenMethodIsCalledMoreThanOnce() {
    // Given
    let verificationData = dummyVerificationData(timesInvoked: 3)
    let sut = AtLeastOnce()

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    // When
    sut.verify(verificationData, mockFailer: mockFailer)

    // Then
    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)
  }

}


// MARK:- Test cases for custom verification mode `AtMostOnce`


extension VerificationModeTests {

  func testVerificationModeAtMostOnceSucceedsWhenMethodIsCalledLessThanOnce() {
    // Given
    let verificationData = dummyVerificationData(timesInvoked: 0)
    let sut = AtMostOnce()

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    // When
    sut.verify(verificationData, mockFailer: mockFailer)

    // Then
    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)
  }

  func testVerificationModeAtMostOnceSucceedsWhenMethodIsCalledOnce() {
    // Given
    let verificationData = dummyVerificationData(timesInvoked: 1)
    let sut = AtMostOnce()

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    // When
    sut.verify(verificationData, mockFailer: mockFailer)

    // Then
    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)
  }

  func testVerificationModeAtMostOnceFailsWhenMethodIsCalledMoreThanOnce() {
    // Given
    let verificationData = dummyVerificationData(timesInvoked: 3)
    let sut = AtMostOnce()

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    // When
    sut.verify(verificationData, mockFailer: mockFailer)

    // Then
    XCTAssertEqual(mockFailer.message, String(format: StringConstants.FailureMessages.verificationModeAtMostOnce,
      verificationData.functionName, verificationData.timesInvoked))
    XCTAssertEqual(mockFailer.file, "thisFile")
    XCTAssertEqual(mockFailer.line, 1)
  }

}


// MARK:- Test cases for custom verification mode `Times`


extension VerificationModeTests {

  func testVerificationModeTimesSucceedsWhenMethodIsCalledGivenTimes() {
    // Given
    let verificationData = dummyVerificationData(timesInvoked: 3)
    let sut = Times(times: 3)

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    // When
    sut.verify(verificationData, mockFailer: mockFailer)

    // Then
    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)
  }

  func testVerificationModeTimesFailsWhenMethodIsCalledLessThanGivenTimes() {
    // Given
    let verificationData = dummyVerificationData(timesInvoked: 2)
    let sut = Times(times: 3)

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    // When
    sut.verify(verificationData, mockFailer: mockFailer)

    // Then
    XCTAssertEqual(mockFailer.message, String(format: StringConstants.FailureMessages.verificationModeTimes,
      verificationData.functionName, 3, verificationData.timesInvoked))
    XCTAssertEqual(mockFailer.file, "thisFile")
    XCTAssertEqual(mockFailer.line, 1)
  }

  func testVerificationModeTimesFailsWhenMethodIsCalledMoreThanGivenTimes() {
    // Given
    let verificationData = dummyVerificationData(timesInvoked: 4)
    let sut = Times(times: 3)

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    // When
    sut.verify(verificationData, mockFailer: mockFailer)

    // Then
    XCTAssertEqual(mockFailer.message, String(format: StringConstants.FailureMessages.verificationModeTimes,
      verificationData.functionName, 3, verificationData.timesInvoked))
    XCTAssertEqual(mockFailer.file, "thisFile")
    XCTAssertEqual(mockFailer.line, 1)
  }

}


// MARK:- Test cases for custom verification mode `AtLeastTimes`


extension VerificationModeTests {

  func testVerificationModeAtLeastTimesSucceedsWhenMethodIsCalledGivenTimes() {
    // Given
    let verificationData = dummyVerificationData(timesInvoked: 3)
    let sut = AtLeastTimes(times: Times(times: 3))

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    // When
    sut.verify(verificationData, mockFailer: mockFailer)

    // Then
    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)
  }

  func testVerificationModeAtLeastTimesFailsWhenMethodIsCalledLessThanGivenTimes() {
    // Given
    let verificationData = dummyVerificationData(timesInvoked: 2)
    let sut = AtLeastTimes(times: Times(times: 3))

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    // When
    sut.verify(verificationData, mockFailer: mockFailer)

    // Then
    XCTAssertEqual(mockFailer.message, String(format: StringConstants.FailureMessages.verificationModeAtLeastTimes,
      verificationData.functionName, 3, verificationData.timesInvoked))
    XCTAssertEqual(mockFailer.file, "thisFile")
    XCTAssertEqual(mockFailer.line, 1)
  }

  func testVerificationModeAtLeastTimesSucceedsWhenMethodIsCalledMoreThanGivenTimes() {
    // Given
    let verificationData = dummyVerificationData(timesInvoked: 4)
    let sut = AtLeastTimes(times: Times(times: 3))

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    // When
    sut.verify(verificationData, mockFailer: mockFailer)

    // Then
    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)
  }

}


// MARK:- Test cases for custom verification mode `AtMostTimes`


extension VerificationModeTests {

  func testVerificationModeAtMostTimesSucceedsWhenMethodIsCalledGivenTimes() {
    // Given
    let verificationData = dummyVerificationData(timesInvoked: 3)
    let sut = AtMostTimes(times: Times(times: 3))

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    // When
    sut.verify(verificationData, mockFailer: mockFailer)

    // Then
    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)
  }

  func testVerificationModeAtMostTimesSucceedsWhenMethodIsCalledLessThanGivenTimes() {
    // Given
    let verificationData = dummyVerificationData(timesInvoked: 2)
    let sut = AtMostTimes(times: Times(times: 3))

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    // When
    sut.verify(verificationData, mockFailer: mockFailer)

    // Then
    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)
  }

  func testVerificationModeAtMostTimesFailsWhenMethodIsCalledMoreThanGivenTimes() {
    // Given
    let verificationData = dummyVerificationData(timesInvoked: 4)
    let sut = AtMostTimes(times: Times(times: 3))

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    // When
    sut.verify(verificationData, mockFailer: mockFailer)

    // Then
    XCTAssertEqual(mockFailer.message, String(format: StringConstants.FailureMessages.verificationModeAtMostTimes,
      verificationData.functionName, 3, verificationData.timesInvoked))
    XCTAssertEqual(mockFailer.file, "thisFile")
    XCTAssertEqual(mockFailer.line, 1)
  }

}


// MARK:- Test cases for custom verification mode `Never`


extension VerificationModeTests {

  func testVerificationModeNeverSucceedsWhenMethodIsNotCalled() {
    // Given
    let verificationData = dummyVerificationData(timesInvoked: 0)
    let sut = Never()

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    // When
    sut.verify(verificationData, mockFailer: mockFailer)

    // Then
    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)
  }

  func testVerificationModeNeverFailsWhenMethodIsCalled() {
    // Given
    let verificationData = dummyVerificationData(timesInvoked: 1)
    let sut = Never()

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    // When
    sut.verify(verificationData, mockFailer: mockFailer)

    // Then
    XCTAssertEqual(mockFailer.message, String(format: StringConstants.FailureMessages.verificationModeNever,
      verificationData.functionName, verificationData.timesInvoked))
    XCTAssertEqual(mockFailer.file, "thisFile")
    XCTAssertEqual(mockFailer.line, 1)
  }

}


// MARK:- Test cases for custom verification mode `Only`


extension VerificationModeTests {

  func testVerificationModeOnlySucceedsWhenMethodIsOnlyCalled() {
    // Given
    let verificationData = dummyVerificationData(timesInvoked: 2, calledOnly: true)
    let sut = Only()

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    // When
    sut.verify(verificationData, mockFailer: mockFailer)

    // Then
    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)
  }

  func testVerificationModeOnlyFailsWhenMethodIsNotOnlyCalled() {
    // Given
    let verificationData = dummyVerificationData(timesInvoked: 1, calledOnly: false)
    let sut = Only()

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    // When
    sut.verify(verificationData, mockFailer: mockFailer)

    // Then
    XCTAssertEqual(mockFailer.message, String(format: StringConstants.FailureMessages.verificationModeOnly,
      verificationData.functionName))
    XCTAssertEqual(mockFailer.file, "thisFile")
    XCTAssertEqual(mockFailer.line, 1)
  }

}
