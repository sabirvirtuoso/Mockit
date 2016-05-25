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


// MARK:- Test cases for `IntMatcher`


extension MockMatcherTests {

  func testSameIntArgumentsMatch() {
    //given
    let firstArgument = 10
    let secondArgument = 10

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDifferentIntArgumentsDoNotMatch() {
    //given
    let firstArgument = 10
    let secondArgument = 15

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }
}


// MARK:- Test cases for `DoubleMatcher`


extension MockMatcherTests {

  func testSameDoubleArgumentsMatch() {
    //given
    let firstArgument = 10.120
    let secondArgument = 10.120

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDifferentDoubleArgumentsDoNotMatch() {
    //given
    let firstArgument = 10.130
    let secondArgument = 10.120

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }
}


// MARK:- Test cases for `FloatMatcher`


extension MockMatcherTests {

  func testSameFloatArgumentsMatch() {
    //given
    let firstArgument = 10.5
    let secondArgument = 10.5

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDifferentFloatArgumentsDoNotMatch() {
    //given
    let firstArgument = 10.6
    let secondArgument = 10.7

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }
}


// MARK:- Test cases for `OptionalArrayMatcher`


extension MockMatcherTests {

  func testEmptyOptionalArrayArgumentsMatch() {
    //given
    let firstArgument: [Any?] = []
    let secondArgument: [Any?] = []

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testSameOptionalStringArrayArgumentsMatch() {
    //given
    let firstArgument: [String?] = ["one", "two", nil]
    let secondArgument: [String?] = ["one", "two", nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDifferentOptionalStringArrayArgumentsDoNotMatch() {
    //given
    let firstArgument: [String?] = ["one", "two", nil]
    let secondArgument: [String?] = ["one", "three", nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDifferentNumberOfOptionalStringArrayArgumentsDoNotMatch() {
    //given
    let firstArgument: [String?] = ["one", "two", nil]
    let secondArgument: [String?] = ["one", nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }
  
  func testSameOptionalIntArrayArgumentsMatch() {
    //given
    let firstArgument: [Int?] = [1, 2, nil]
    let secondArgument: [Int?] = [1, 2, nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDifferentOptionalIntArrayArgumentsDoNotMatch() {
    //given
    let firstArgument: [Int?] = [2, 1, nil]
    let secondArgument: [Int?] = [2, 2, nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDifferentNumberOfOptionalIntArrayArgumentsDoNotMatch() {
    //given
    let firstArgument: [Int?] = [2, 1, nil]
    let secondArgument: [Int?] = [2, nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testSameOptionalBoolArrayArgumentsMatch() {
    //given
    let firstArgument: [Bool?] = [true, false, nil]
    let secondArgument: [Bool?] = [true, false, nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDifferentOptionalBoolArrayArgumentsDoNotMatch() {
    //given
    let firstArgument: [Bool?] = [true, false, nil]
    let secondArgument: [Bool?] = [false, true, nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDifferentNumberOfOptionalBoolArrayArgumentsDoNotMatch() {
    //given
    let firstArgument: [Bool?] = [true, true, nil]
    let secondArgument: [Bool?] = [true, nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testSameOptionalDoubleArrayArgumentsMatch() {
    //given
    let firstArgument: [Double?] = [10.120, 10.130, nil]
    let secondArgument: [Double?] = [10.120, 10.130, nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDifferentOptionalDoubleArrayArgumentsDoNotMatch() {
    //given
    let firstArgument: [Double?] = [10.12, 10.5, nil]
    let secondArgument: [Double?] = [10.4, 10.12, nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDifferentNumberOfOptionalDoubleArrayArgumentsDoNotMatch() {
    //given
    let firstArgument: [Double?] = [10.5, 10.2, nil]
    let secondArgument: [Double?] = [10.5, nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testSameOptionalFloatArrayArgumentsMatch() {
    //given
    let firstArgument: [Float?] = [10.5, 10.6, nil]
    let secondArgument: [Float?] = [10.5, 10.6, nil]

    let sut = mockMatcher
    
    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDifferentOptionalFloatArrayArgumentsDoNotMatch() {
    //given
    let firstArgument: [Float?] = [10.5, 10.7, nil]
    let secondArgument: [Float?] = [10.4, 10.2, nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDifferentNumberOfOptionalFloatArrayArgumentsDoNotMatch() {
    //given
    let firstArgument: [Float?] = [10.5, 10.2, nil]
    let secondArgument: [Float?] = [10.5, nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }
}


// MARK:- Test cases for `NonOptionalArrayMatcher`


extension MockMatcherTests {

  func testEmptyArrayArgumentsMatch() {
    //given
    let firstArgument = []
    let secondArgument = []

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testSameStringArrayArgumentsMatch() {
    //given
    let firstArgument = ["one", "two"]
    let secondArgument = ["one", "two"]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDifferentStringArrayArgumentsDoNotMatch() {
    //given
    let firstArgument = ["one", "two"]
    let secondArgument = ["one", "three"]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDifferentNumberOfStringArrayArgumentsDoNotMatch() {
    //given
    let firstArgument = ["one", "two"]
    let secondArgument = ["one"]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testSameIntArrayArgumentsMatch() {
    //given
    let firstArgument = [1, 2]
    let secondArgument = [1, 2]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDifferentIntArrayArgumentsDoNotMatch() {
    //given
    let firstArgument = [2, 1]
    let secondArgument = [2, 2]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDifferentNumberOfIntArrayArgumentsDoNotMatch() {
    //given
    let firstArgument = [2, 1]
    let secondArgument = [2]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testSameBoolArrayArgumentsMatch() {
    //given
    let firstArgument = [true, false]
    let secondArgument = [true, false]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDifferentBoolArrayArgumentsDoNotMatch() {
    //given
    let firstArgument = [true, false]
    let secondArgument = [false, true]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDifferentNumberOfBoolArrayArgumentsDoNotMatch() {
    //given
    let firstArgument = [true, true]
    let secondArgument = [true]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testSameDoubleArrayArgumentsMatch() {
    //given
    let firstArgument = [10.120, 10.130]
    let secondArgument = [10.120, 10.130]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDifferentDoubleArrayArgumentsDoNotMatch() {
    //given
    let firstArgument = [10.12, 10.5]
    let secondArgument = [10.4, 10.12]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDifferentNumberOfDoubleArrayArgumentsDoNotMatch() {
    //given
    let firstArgument = [10.5, 10.2]
    let secondArgument = [10.5]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testSameFloatArrayArgumentsMatch() {
    //given
    let firstArgument = [10.5, 10.6]
    let secondArgument = [10.5, 10.6]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDifferentFloatArrayArgumentsDoNotMatch() {
    //given
    let firstArgument = [10.5, 10.7]
    let secondArgument = [10.4, 10.2]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDifferentNumberOfFloatArrayArgumentsDoNotMatch() {
    //given
    let firstArgument = [10.5, 10.2]
    let secondArgument = [10.5]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }
}


// MARK:- Test cases for `NonOptionalDictionaryMatcher` with String key


extension MockMatcherTests {

  func testEmptyDictionaryWithStringKeysArgumentsMatch() {
    //given
    let firstArgument: [String: Any] = [:]
    let secondArgument: [String: Any] = [:]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameStringKeysAndSameIntValuesMatch() {
    //given
    let firstArgument = ["one" : 1, "two" : 2, "three" : 3]
    let secondArgument = ["one" : 1, "two" : 2, "three" : 3]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameStringKeysAndDifferentIntValuesDoNotMatch() {
    //given
    let firstArgument = ["one" : 1, "two" : 4, "three" : 7]
    let secondArgument = ["one" : 1, "two" : 2, "three" : 3]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentStringKeysAndSameIntValuesDoNotMatch() {
    //given
    let firstArgument = ["one" : 1, "three" : 2, "four" : 3]
    let secondArgument = ["one" : 1, "two" : 2, "three" : 3]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentStringKeysAndDifferentIntValuesDoNotMatch() {
    //given
    let firstArgument = ["one" : 2, "two" : 3, "three" : 4]
    let secondArgument = ["three" : 1, "two" : 2, "one" : 3]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentNumberOfStringKeyIntValuePairsDoNotMatch() {
    //given
    let firstArgument = ["one" : 1, "two" : 2]
    let secondArgument = ["one" : 1, "two" : 2, "three" : 3]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithSameStringKeysAndSameStringValuesMatch() {
    //given
    let firstArgument = ["one" : "one", "two" : "two", "three" : "three"]
    let secondArgument = ["one" : "one", "two" : "two", "three" : "three"]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameStringKeysAndDifferentStringValuesDoNotMatch() {
    //given
    let firstArgument = ["one" : "one", "two" : "two", "three" : "three"]
    let secondArgument = ["one" : "two", "two" : "one", "three" : "two"]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentStringKeysAndSameStringValuesDoNotMatch() {
    //given
    let firstArgument = ["one" : "one", "three" : "three", "four" : "four"]
    let secondArgument = ["one" : "one", "two" : "three", "three" : "four"]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentStringKeysAndDifferentStringValuesDoNotMatch() {
    //given
    let firstArgument = ["one" : "one", "two" : "three", "three" : "two"]
    let secondArgument = ["three" : "two", "two" : "one", "one" : "three"]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentNumberOfStringKeyStringValuePairsDoNotMatch() {
    //given
    let firstArgument = ["one" : "one", "two" : "two"]
    let secondArgument = ["one" : "one", "two" : "two", "three" : "three"]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithSameStringKeysAndSameAnyValuesMatch() {
    //given
    let firstArgument: [String: Any] = ["one" : "one", "two" : 2, "three" : "three"]
    let secondArgument: [String: Any] = ["one" : "one", "two" : 2, "three" : "three"]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameStringKeysAndDifferentAnyValuesDoNotMatch() {
    //given
    let firstArgument: [String: Any] = ["one" : "one", "two" : true, "three" : 3]
    let secondArgument: [String: Any] = ["one" : "two", "two" : false, "three" : 3]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentStringKeysAndSameAnyValuesDoNotMatch() {
    //given
    let firstArgument: [String: Any] = ["one" : "one", "three" : "three", "four" : "four"]
    let secondArgument: [String: Any] = ["one" : "one", "two" : "three", "three" : "four"]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentStringKeysAndDifferentAnyValuesDoNotMatch() {
    //given
    let firstArgument: [String: Any] = ["one" : "one", "two" : 1, "three" : "two"]
    let secondArgument: [String: Any] = ["three" : "two", "two" : 2, "one" : "three"]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentNumberOfStringKeyAnyValuePairsDoNotMatch() {
    //given
    let firstArgument: [String: Any] = ["one" : "one", "two" : 2]
    let secondArgument: [String: Any] = ["one" : "one", "two" : 2, "three" : true]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }
}


// MARK:- Test cases for `NonOptionalDictionaryMatcher` with Int key


extension MockMatcherTests {

  func testEmptyDictionaryWithIntKeysArgumentsMatch() {
    //given
    let firstArgument: [Int: Any] = [:]
    let secondArgument: [Int: Any] = [:]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameIntKeysAndSameIntValuesMatch() {
    //given
    let firstArgument = [1 : 1, 2 : 2, 3 : 3]
    let secondArgument = [1 : 1, 2 : 2, 3 : 3]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameIntKeysAndDifferentIntValuesDoNotMatch() {
    //given
    let firstArgument = [1 : 1, 2 : 4, 3 : 7]
    let secondArgument = [1 : 1, 2 : 2, 3 : 3]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentIntKeysAndSameIntValuesDoNotMatch() {
    //given
    let firstArgument = [1 : 1, 3 : 2, 4 : 3]
    let secondArgument = [1 : 1, 2 : 2, 3 : 3]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentIntKeysAndDifferentIntValuesDoNotMatch() {
    //given
    let firstArgument = [1 : 2, 2 : 3, 3 : 4]
    let secondArgument = [3 : 1, 2 : 2, 1 : 3]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentNumberOfIntKeyIntValuePairsDoNotMatch() {
    //given
    let firstArgument = [1 : 1, 2 : 2]
    let secondArgument = [1 : 1, 2 : 2, 3 : 3]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithSameIntKeysAndSameStringValuesMatch() {
    //given
    let firstArgument = [1 : "one", 2 : "two", 3 : "three"]
    let secondArgument = [1 : "one", 2 : "two", 3 : "three"]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameIntKeysAndDifferentStringValuesDoNotMatch() {
    //given
    let firstArgument = [1 : "one", 2 : "two", 3 : "three"]
    let secondArgument = [1 : "two", 2 : "one", 3 : "two"]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentIntKeysAndSameStringValuesDoNotMatch() {
    //given
    let firstArgument = [1 : "one", 3 : "three", 4 : "four"]
    let secondArgument = [1 : "one", 2 : "three", 3 : "four"]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentIntKeysAndDifferentStringValuesDoNotMatch() {
    //given
    let firstArgument = [1 : "one", 2 : "three", 3 : "two"]
    let secondArgument = [3 : "two", 2 : "one", 1 : "three"]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentNumberOfIntKeyStringValuePairsDoNotMatch() {
    //given
    let firstArgument = [1 : "one", 2 : "two"]
    let secondArgument = [1 : "one", 2 : "two", 3 : "three"]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithSameIntKeysAndSameAnyValuesMatch() {
    //given
    let firstArgument: [Int: Any] = [1 : "one", 2 : 2, 3 : "three"]
    let secondArgument: [Int: Any] = [1 : "one", 2 : 2, 3 : "three"]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameIntKeysAndDifferentAnyValuesDoNotMatch() {
    //given
    let firstArgument: [Int: Any] = [1 : "one", 2 : true, 3 : 3]
    let secondArgument: [Int: Any] = [1 : "two", 2 : false, 3 : 3]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentIntKeysAndSameAnyValuesDoNotMatch() {
    //given
    let firstArgument: [Int: Any] = [1 : "one", 3 : "three", 4 : "four"]
    let secondArgument: [Int: Any] = [1 : "one", 2 : "three", 3 : "four"]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentIntKeysAndDifferentAnyValuesDoNotMatch() {
    //given
    let firstArgument: [Int: Any] = [1 : "one", 2 : 1, 3 : "two"]
    let secondArgument: [Int: Any] = [3 : "two", 2 : 2, 1 : "three"]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentNumberOfIntKeyAnyValuePairsDoNotMatch() {
    //given
    let firstArgument: [Int: Any] = [1 : "one", 2 : 2]
    let secondArgument: [Int: Any] = [1 : "one", 2 : 2, 3 : true]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }
}


// MARK:- Test cases for `OptionalDictionaryMatcher` with String key


extension MockMatcherTests {

  func testEmptyOptionalDictionaryWithStringKeysArgumentsMatch() {
    //given
    let firstArgument: [String: Any?] = [:]
    let secondArgument: [String: Any?] = [:]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameStringKeysAndSameOptionalIntValuesMatch() {
    //given
    let firstArgument: [String: Int?] = ["one" : 1, "two" : 2, "three" : 3, "four" : nil]
    let secondArgument: [String: Int?] = ["one" : 1, "two" : 2, "three" : 3, "four" : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameStringKeysAndDifferentOptionalIntValuesDoNotMatch() {
    //given
    let firstArgument: [String: Int?] = ["one" : 1, "two" : 4, "three" : 7, "four" : nil]
    let secondArgument: [String: Int?] = ["one" : 1, "two" : 2, "three" : 3, "four" : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentStringKeysAndSameOptionalIntValuesDoNotMatch() {
    //given
    let firstArgument: [String: Int?] = ["one" : 1, "three" : 2, "four" : 3, "two" : nil]
    let secondArgument: [String: Int?] = ["one" : 1, "two" : 2, "three" : 3, "four" : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentStringKeysAndDifferentOptionalIntValuesDoNotMatch() {
    //given
    let firstArgument: [String: Int?] = ["one" : 2, "two" : 3, "three" : 4, "four" : nil]
    let secondArgument: [String: Int?] = ["three" : 1, "two" : 2, "one" : 3, "four" : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentNumberOfStringKeyOptionalIntValuePairsDoNotMatch() {
    //given
    let firstArgument: [String: Int?] = ["one" : 1, "two" : 2, "three" : nil]
    let secondArgument: [String: Int?] = ["one" : 1, "two" : 2, "three" : 3, "four" : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithSameStringKeysAndSameOptionalStringValuesMatch() {
    //given
    let firstArgument: [String: String?] = ["one" : "one", "two" : "two", "three" : "three", "four" : nil]
    let secondArgument: [String: String?] = ["one" : "one", "two" : "two", "three" : "three", "four" : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameStringKeysAndDifferentOptionalStringValuesDoNotMatch() {
    //given
    let firstArgument: [String: String?] = ["one" : "one", "two" : "two", "three" : "three", "four" : nil]
    let secondArgument: [String: String?] = ["one" : "two", "two" : "one", "three" : "two", "four" : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentStringKeysAndSameOptionalStringValuesDoNotMatch() {
    //given
    let firstArgument: [String: String?] = ["one" : "one", "three" : "three", "four" : "four", "two" : nil]
    let secondArgument: [String: String?] = ["one" : "one", "two" : "three", "three" : "four", "four" : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentStringKeysAndDifferentOptionalStringValuesDoNotMatch() {
    //given
    let firstArgument: [String: String?] = ["one" : "one", "two" : "three", "three" : "two", "four" : nil]
    let secondArgument: [String: String?] = ["three" : "two", "two" : "one", "one" : "three", "four" : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentNumberOfStringKeyOptionalStringValuePairsDoNotMatch() {
    //given
    let firstArgument: [String: String?] = ["one" : "one", "two" : "two", "three" : nil]
    let secondArgument: [String: String?] = ["one" : "one", "two" : "two", "three" : "three", "four" : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithSameStringKeysAndSameOptionalAnyValuesMatch() {
    //given
    let firstArgument: [String: Any?] = ["one" : "one", "two" : 2, "three" : "three", "four" : nil]
    let secondArgument: [String: Any?] = ["one" : "one", "two" : 2, "three" : "three", "four" : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameStringKeysAndDifferentOptionalAnyValuesDoNotMatch() {
    //given
    let firstArgument: [String: Any?] = ["one" : "one", "two" : true, "three" : 3, "four" : nil]
    let secondArgument: [String: Any?] = ["one" : "two", "two" : false, "three" : 3, "four" : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentStringKeysAndSameOptionalAnyValuesDoNotMatch() {
    //given
    let firstArgument: [String: Any?] = ["one" : "one", "three" : "three", "four" : "four", "two" : nil]
    let secondArgument: [String: Any?] = ["one" : "one", "two" : "three", "three" : "four", "four" : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentStringKeysAndDifferentOptionalAnyValuesDoNotMatch() {
    //given
    let firstArgument: [String: Any?] = ["one" : "one", "two" : 1, "three" : "two", "four" : nil]
    let secondArgument: [String: Any?] = ["three" : "two", "two" : 2, "one" : "three", "four" : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentNumberOfStringKeyOptionalAnyValuePairsDoNotMatch() {
    //given
    let firstArgument: [String: Any?] = ["one" : "one", "two" : 2, "three" : nil]
    let secondArgument: [String: Any?] = ["one" : "one", "two" : 2, "three" : true, "four" : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }
}


// MARK:- Test cases for `OptionalDictionaryMatcher` with Int key


extension MockMatcherTests {

  func testEmptyOptionalDictionaryWithIntKeysArgumentsMatch() {
    //given
    let firstArgument: [Int: Any?] = [:]
    let secondArgument: [Int: Any?] = [:]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameIntKeysAndSameOptionalIntValuesMatch() {
    //given
    let firstArgument: [Int: Int?] = [1 : 1, 2 : 2, 3 : 3, 4 : nil]
    let secondArgument: [Int: Int?] = [1 : 1, 2 : 2, 3 : 3, 4 : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameIntKeysAndDifferentOptionalIntValuesDoNotMatch() {
    //given
    let firstArgument: [Int: Int?] = [1 : 1, 2 : 4, 3 : 7, 4: nil]
    let secondArgument: [Int: Int?] = [1 : 1, 2 : 2, 3 : 3, 4: nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentIntKeysAndSameOptionalIntValuesDoNotMatch() {
    //given
    let firstArgument: [Int: Int?] = [1 : 1, 3 : 2, 4 : 3, 2: nil]
    let secondArgument : [Int: Int?] = [1 : 1, 2 : 2, 3 : 3, 4: nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentIntKeysAndDifferentOptionalIntValuesDoNotMatch() {
    //given
    let firstArgument: [Int: Int?] = [1 : 2, 2 : 3, 3 : 4, 4 : nil]
    let secondArgument: [Int: Int?] = [3 : 1, 2 : 2, 1 : 3, 4 : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentNumberOfIntKeyOptionalIntValuePairsDoNotMatch() {
    //given
    let firstArgument: [Int: Int?] = [1 : 1, 2 : 2, 3 : nil]
    let secondArgument: [Int: Int?] = [1 : 1, 2 : 2, 3 : 3, 4: nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithSameIntKeysAndSameOptionalStringValuesMatch() {
    //given
    let firstArgument: [Int: String?] = [1 : "one", 2 : "two", 3 : "three", 4 : nil]
    let secondArgument: [Int: String?] = [1 : "one", 2 : "two", 3 : "three", 4 : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameIntKeysAndDifferentOptionalStringValuesDoNotMatch() {
    //given
    let firstArgument: [Int: String?] = [1 : "one", 2 : "two", 3 : "three", 4 : nil]
    let secondArgument: [Int: String?] = [1 : "two", 2 : "one", 3 : "two", 4 : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentIntKeysAndSameOptionalStringValuesDoNotMatch() {
    //given
    let firstArgument: [Int: String?] = [1 : "one", 3 : "three", 4 : "four", 2 : nil]
    let secondArgument: [Int: String?] = [1 : "one", 2 : "three", 3 : "four", 4 : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentIntKeysAndDifferentOptionalStringValuesDoNotMatch() {
    //given
    let firstArgument: [Int: String?] = [1 : "one", 2 : "three", 3 : "two", 4 : nil]
    let secondArgument: [Int: String?] = [3 : "two", 2 : "one", 1 : "three", 4 : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentNumberOfIntKeyOptionalStringValuePairsDoNotMatch() {
    //given
    let firstArgument: [Int: String?] = [1 : "one", 2 : "two", 3 : nil]
    let secondArgument: [Int: String?] = [1 : "one", 2 : "two", 3 : "three", 4 : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithSameIntKeysAndSameOptionalAnyValuesMatch() {
    //given
    let firstArgument: [Int: Any?] = [1 : "one", 2 : 2, 3 : "three", 4 : nil]
    let secondArgument: [Int: Any?] = [1 : "one", 2 : 2, 3 : "three", 4 : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameIntKeysAndDifferentOptionalAnyValuesDoNotMatch() {
    //given
    let firstArgument: [Int: Any?] = [1 : "one", 2 : true, 3 : 3, 4 : nil]
    let secondArgument: [Int: Any?] = [1 : "two", 2 : false, 3 : 3, 4 : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentIntKeysAndSameOptionalAnyValuesDoNotMatch() {
    //given
    let firstArgument: [Int: Any?] = [1 : "one", 3 : "three", 4 : "four", 2 : nil]
    let secondArgument: [Int: Any?] = [1 : "one", 2 : "three", 3 : "four", 4 : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentIntKeysAndDifferentOptionalAnyValuesDoNotMatch() {
    //given
    let firstArgument: [Int: Any?] = [1 : "one", 2 : 1, 3 : "two", 4 : nil]
    let secondArgument: [Int: Any?] = [3 : "two", 2 : 2, 1 : "three", 4 : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentNumberOfIntKeyOptionalAnyValuePairsDoNotMatch() {
    //given
    let firstArgument: [Int: Any?] = [1 : "one", 2 : 2, 3 : nil]
    let secondArgument: [Int: Any?] = [1 : "one", 2 : 2, 3 : true, 4 : nil]

    let sut = mockMatcher

    //when
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    //then
    XCTAssertFalse(result)
  }
}
