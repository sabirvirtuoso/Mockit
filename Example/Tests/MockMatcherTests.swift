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


// MARK:- Test cases for `MockMatcher`


class MockMatcherTests: XCTestCase {

  var mockMatcher: MockMatcher!

  override func setUp() {
    mockMatcher = MockMatcher.sharedInstance
  }

  func testBothNilArgumentsMatch() {
    //given
    let sut = mockMatcher

    //when
    let result = sut.match(arguments: nil, withArguments: nil)

    //then
    XCTAssertTrue(result)
  }

  func testNilAndNonNilArgumentsDoNotMatch() {
    //given
    let sut = mockMatcher

    //when
    let result = sut.match(arguments: nil, withArguments: "Non Nil")

    //then
    XCTAssertFalse(result)
  }

  func testNonNilAndNilArgumentsDoNotMatch() {
    //given
    let sut = mockMatcher

    //when
    let result = sut.match(arguments: 2, withArguments: nil)

    //then
    XCTAssertFalse(result)
  }
}


// MARK:- Test cases for `StringMatcher`


extension MockMatcherTests {

  func testSameStringArgumentsMatch() {
    //given
    let firstArgument = "argument"
    let secondArgument = "argument"

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDifferentStringArgumentsDoNotMatch() {
    //given
    let firstArgument = "argument"
    let secondArgument = "argumentTwo"

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }
}


// MARK:- Test cases for `BoolMatcher`


extension MockMatcherTests {

  func testSameBoolArgumentsMatch() {
    //given
    let firstArgument = true
    let secondArgument = true

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDifferentBoolArgumentsDoNotMatch() {
    //given
    let firstArgument = true
    let secondArgument = false

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }
}
