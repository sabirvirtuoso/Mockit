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
  var line: UInt?

  func doFail(message: String, file: String, line: UInt) {
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

  private func dummyVerificationData(timesInvoked times: Int, calledOnly: Bool = false) -> VerificationData {
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

  func testVerificationModeFailsWhenMethodIsCalledLessThanOnce() {
    //given
    let verificationData = dummyVerificationData(timesInvoked: 0)
    let sut = Once()

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    //when
    sut.verify(verificationData, mockFailer: mockFailer)

    //then
    XCTAssertEqual(mockFailer.message, "Expected \(verificationData.functionName) to be called Once. It is actually called \(verificationData.timesInvoked) times")
    XCTAssertEqual(mockFailer.file, "thisFile")
    XCTAssertEqual(mockFailer.line, 1)
  }

  func testVerificationModeSucceedsWhenMethodIsCalledOnce() {
    //given
    let verificationData = dummyVerificationData(timesInvoked: 1)
    let sut = Once()

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    //when
    sut.verify(verificationData, mockFailer: mockFailer)

    //then
    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)
  }

  func testVerificationModeFailsWhenMethodIsCalledMoreThanOnce() {
    //given
    let verificationData = dummyVerificationData(timesInvoked: 3)
    let sut = Once()

    XCTAssertNil(mockFailer.message)
    XCTAssertNil(mockFailer.file)
    XCTAssertNil(mockFailer.line)

    //when
    sut.verify(verificationData, mockFailer: mockFailer)

    //then
    XCTAssertEqual(mockFailer.message, "Expected \(verificationData.functionName) to be called Once. It is actually called \(verificationData.timesInvoked) times")
    XCTAssertEqual(mockFailer.file, "thisFile")
    XCTAssertEqual(mockFailer.line, 1)
  }
}




