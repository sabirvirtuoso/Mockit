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


// MARK:- This class will match OK


class DifferentClassForMatching {

}


// MARK:- This class will not match


class AnotherDifferentClassForMatching {

}


// MARK:- Custom Type Matcher


public class CustomMatcher: TypeMatcher {

  public func match(argument arg: Any, withArgument withArg: Any) -> Bool {
    switch (arg, withArg) {
      case ( _ as DifferentClassForMatching, _ as DifferentClassForMatching):
        return true
      case ( _ as AnotherDifferentClassForMatching, _ as AnotherDifferentClassForMatching):
        return false
      default:
        return false
    }
  }

}


// MARK:- Test cases for `MockMatcher`


class MockMatcherTests: XCTestCase {

  var mockMatcher: MockMatcher!

  override func setUp() {
    mockMatcher = MockMatcher.sharedInstance
  }

  func testBothNilArgumentsMatch() {
    // Given
    let sut = mockMatcher

    // When
    let result = sut.match(arguments: nil, withArguments: nil)

    // Then
    XCTAssertTrue(result)
  }

  func testNilAndNonNilArgumentsDoNotMatch() {
    // Given
    let sut = mockMatcher

    // When
    let result = sut.match(arguments: nil, withArguments: "Non Nil")

    // Then
    XCTAssertFalse(result)
  }

  func testNonNilAndNilArgumentsDoNotMatch() {
    // Given
    let sut = mockMatcher

    // When
    let result = sut.match(arguments: 2, withArguments: nil)

    // Then
    XCTAssertFalse(result)
  }

  func testCustomMatcherRegistration() {
    // Given
    let sut = mockMatcher

    sut.register(CustomMatcher.self, typeMatcher: CustomMatcher())
    let classToMatch = DifferentClassForMatching()

    // When
    let result = sut.match(arguments: classToMatch, withArguments: classToMatch)

    // Then
    XCTAssertTrue(result)
  }

  func testCustomMatcherUnregistration() {
    // Given
    let sut = mockMatcher

    sut.unregister(CustomMatcher.self)

    let classToMatch = DifferentClassForMatching()

    // When
    let result = sut.match(arguments: classToMatch, withArguments: classToMatch)

    // Then
    XCTAssertFalse(result)
  }

}


// MARK:- Test cases for `StringMatcher`


extension MockMatcherTests {

  func testSameStringArgumentsMatch() {
    // Given
    let firstArgument = "argument"
    let secondArgument = "argument"

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDifferentStringArgumentsDoNotMatch() {
    // Given
    let firstArgument = "argument"
    let secondArgument = "argumentTwo"

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

}


// MARK:- Test cases for `BoolMatcher`


extension MockMatcherTests {

  func testSameBoolArgumentsMatch() {
    // Given
    let firstArgument = true
    let secondArgument = true

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDifferentBoolArgumentsDoNotMatch() {
    // Given
    let firstArgument = true
    let secondArgument = false

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

}


// MARK:- Test cases for `IntMatcher`


extension MockMatcherTests {

  func testSameIntArgumentsMatch() {
    // Given
    let firstArgument = 10
    let secondArgument = 10

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDifferentIntArgumentsDoNotMatch() {
    // Given
    let firstArgument = 10
    let secondArgument = 15

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

}


// MARK:- Test cases for `DoubleMatcher`


extension MockMatcherTests {

  func testSameDoubleArgumentsMatch() {
    // Given
    let firstArgument = 10.120
    let secondArgument = 10.120

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDifferentDoubleArgumentsDoNotMatch() {
    // Given
    let firstArgument = 10.130
    let secondArgument = 10.120

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

}


// MARK:- Test cases for `FloatMatcher`


extension MockMatcherTests {

  func testSameFloatArgumentsMatch() {
    // Given
    let firstArgument = 10.5
    let secondArgument = 10.5

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDifferentFloatArgumentsDoNotMatch() {
    // Given
    let firstArgument = 10.6
    let secondArgument = 10.7

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

}


// MARK:- Test cases for `OptionalArrayMatcher`


extension MockMatcherTests {

  func testEmptyOptionalArrayArgumentsMatch() {
    // Given
    let firstArgument: [Any?] = []
    let secondArgument: [Any?] = []

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testSameOptionalStringArrayArgumentsMatch() {
    // Given
    let firstArgument: [String?] = ["one", "two", nil]
    let secondArgument: [String?] = ["one", "two", nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDifferentOptionalStringArrayArgumentsDoNotMatch() {
    // Given
    let firstArgument: [String?] = ["one", "two", nil]
    let secondArgument: [String?] = ["one", "three", nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDifferentNumberOfOptionalStringArrayArgumentsDoNotMatch() {
    // Given
    let firstArgument: [String?] = ["one", "two", nil]
    let secondArgument: [String?] = ["one", nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }
  
  func testSameOptionalIntArrayArgumentsMatch() {
    // Given
    let firstArgument: [Int?] = [1, 2, nil]
    let secondArgument: [Int?] = [1, 2, nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDifferentOptionalIntArrayArgumentsDoNotMatch() {
    // Given
    let firstArgument: [Int?] = [2, 1, nil]
    let secondArgument: [Int?] = [2, 2, nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDifferentNumberOfOptionalIntArrayArgumentsDoNotMatch() {
    // Given
    let firstArgument: [Int?] = [2, 1, nil]
    let secondArgument: [Int?] = [2, nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testSameOptionalBoolArrayArgumentsMatch() {
    // Given
    let firstArgument: [Bool?] = [true, false, nil]
    let secondArgument: [Bool?] = [true, false, nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDifferentOptionalBoolArrayArgumentsDoNotMatch() {
    // Given
    let firstArgument: [Bool?] = [true, false, nil]
    let secondArgument: [Bool?] = [false, true, nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDifferentNumberOfOptionalBoolArrayArgumentsDoNotMatch() {
    // Given
    let firstArgument: [Bool?] = [true, true, nil]
    let secondArgument: [Bool?] = [true, nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testSameOptionalDoubleArrayArgumentsMatch() {
    // Given
    let firstArgument: [Double?] = [10.120, 10.130, nil]
    let secondArgument: [Double?] = [10.120, 10.130, nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDifferentOptionalDoubleArrayArgumentsDoNotMatch() {
    // Given
    let firstArgument: [Double?] = [10.12, 10.5, nil]
    let secondArgument: [Double?] = [10.4, 10.12, nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDifferentNumberOfOptionalDoubleArrayArgumentsDoNotMatch() {
    // Given
    let firstArgument: [Double?] = [10.5, 10.2, nil]
    let secondArgument: [Double?] = [10.5, nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testSameOptionalFloatArrayArgumentsMatch() {
    // Given
    let firstArgument: [Float?] = [10.5, 10.6, nil]
    let secondArgument: [Float?] = [10.5, 10.6, nil]

    let sut = mockMatcher
    
    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDifferentOptionalFloatArrayArgumentsDoNotMatch() {
    // Given
    let firstArgument: [Float?] = [10.5, 10.7, nil]
    let secondArgument: [Float?] = [10.4, 10.2, nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDifferentNumberOfOptionalFloatArrayArgumentsDoNotMatch() {
    // Given
    let firstArgument: [Float?] = [10.5, 10.2, nil]
    let secondArgument: [Float?] = [10.5, nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

}


// MARK:- Test cases for `NonOptionalArrayMatcher`


extension MockMatcherTests {

  func testEmptyArrayArgumentsMatch() {
    // Given
    let firstArgument = []
    let secondArgument = []

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testSameStringArrayArgumentsMatch() {
    // Given
    let firstArgument = ["one", "two"]
    let secondArgument = ["one", "two"]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDifferentStringArrayArgumentsDoNotMatch() {
    // Given
    let firstArgument = ["one", "two"]
    let secondArgument = ["one", "three"]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDifferentNumberOfStringArrayArgumentsDoNotMatch() {
    // Given
    let firstArgument = ["one", "two"]
    let secondArgument = ["one"]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testSameIntArrayArgumentsMatch() {
    // Given
    let firstArgument = [1, 2]
    let secondArgument = [1, 2]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDifferentIntArrayArgumentsDoNotMatch() {
    // Given
    let firstArgument = [2, 1]
    let secondArgument = [2, 2]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDifferentNumberOfIntArrayArgumentsDoNotMatch() {
    // Given
    let firstArgument = [2, 1]
    let secondArgument = [2]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testSameBoolArrayArgumentsMatch() {
    // Given
    let firstArgument = [true, false]
    let secondArgument = [true, false]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDifferentBoolArrayArgumentsDoNotMatch() {
    // Given
    let firstArgument = [true, false]
    let secondArgument = [false, true]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDifferentNumberOfBoolArrayArgumentsDoNotMatch() {
    // Given
    let firstArgument = [true, true]
    let secondArgument = [true]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testSameDoubleArrayArgumentsMatch() {
    // Given
    let firstArgument = [10.120, 10.130]
    let secondArgument = [10.120, 10.130]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDifferentDoubleArrayArgumentsDoNotMatch() {
    // Given
    let firstArgument = [10.12, 10.5]
    let secondArgument = [10.4, 10.12]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDifferentNumberOfDoubleArrayArgumentsDoNotMatch() {
    // Given
    let firstArgument = [10.5, 10.2]
    let secondArgument = [10.5]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testSameFloatArrayArgumentsMatch() {
    // Given
    let firstArgument = [10.5, 10.6]
    let secondArgument = [10.5, 10.6]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDifferentFloatArrayArgumentsDoNotMatch() {
    // Given
    let firstArgument = [10.5, 10.7]
    let secondArgument = [10.4, 10.2]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDifferentNumberOfFloatArrayArgumentsDoNotMatch() {
    // Given
    let firstArgument = [10.5, 10.2]
    let secondArgument = [10.5]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

}


// MARK:- Test cases for `NonOptionalDictionaryMatcher` with String key


extension MockMatcherTests {

  func testEmptyDictionaryWithStringKeysArgumentsMatch() {
    // Given
    let firstArgument: [String: Any] = [:]
    let secondArgument: [String: Any] = [:]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameStringKeysAndSameIntValuesMatch() {
    // Given
    let firstArgument = ["one": 1, "two": 2, "three": 3]
    let secondArgument = ["one": 1, "two": 2, "three": 3]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameStringKeysAndDifferentIntValuesDoNotMatch() {
    // Given
    let firstArgument = ["one": 1, "two": 4, "three": 7]
    let secondArgument = ["one": 1, "two": 2, "three": 3]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentStringKeysAndSameIntValuesDoNotMatch() {
    // Given
    let firstArgument = ["one": 1, "three": 2, "four": 3]
    let secondArgument = ["one": 1, "two": 2, "three": 3]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentStringKeysAndDifferentIntValuesDoNotMatch() {
    // Given
    let firstArgument = ["one": 2, "two": 3, "three": 4]
    let secondArgument = ["three": 1, "two": 2, "one": 3]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentNumberOfStringKeyIntValuePairsDoNotMatch() {
    // Given
    let firstArgument = ["one": 1, "two": 2]
    let secondArgument = ["one": 1, "two": 2, "three": 3]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithSameStringKeysAndSameStringValuesMatch() {
    // Given
    let firstArgument = ["one": "one", "two": "two", "three": "three"]
    let secondArgument = ["one": "one", "two": "two", "three": "three"]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameStringKeysAndDifferentStringValuesDoNotMatch() {
    // Given
    let firstArgument = ["one": "one", "two": "two", "three": "three"]
    let secondArgument = ["one": "two", "two": "one", "three": "two"]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentStringKeysAndSameStringValuesDoNotMatch() {
    // Given
    let firstArgument = ["one": "one", "three": "three", "four": "four"]
    let secondArgument = ["one": "one", "two": "three", "three": "four"]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentStringKeysAndDifferentStringValuesDoNotMatch() {
    // Given
    let firstArgument = ["one": "one", "two": "three", "three": "two"]
    let secondArgument = ["three": "two", "two": "one", "one": "three"]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentNumberOfStringKeyStringValuePairsDoNotMatch() {
    // Given
    let firstArgument = ["one": "one", "two": "two"]
    let secondArgument = ["one": "one", "two": "two", "three": "three"]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithSameStringKeysAndSameAnyValuesMatch() {
    // Given
    let firstArgument: [String: Any] = ["one": "one", "two": 2, "three": "three"]
    let secondArgument: [String: Any] = ["one": "one", "two": 2, "three": "three"]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameStringKeysAndDifferentAnyValuesDoNotMatch() {
    // Given
    let firstArgument: [String: Any] = ["one": "one", "two": true, "three": 3]
    let secondArgument: [String: Any] = ["one": "two", "two": false, "three": 3]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentStringKeysAndSameAnyValuesDoNotMatch() {
    // Given
    let firstArgument: [String: Any] = ["one": "one", "three": "three", "four": "four"]
    let secondArgument: [String: Any] = ["one": "one", "two": "three", "three": "four"]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentStringKeysAndDifferentAnyValuesDoNotMatch() {
    // Given
    let firstArgument: [String: Any] = ["one": "one", "two": 1, "three": "two"]
    let secondArgument: [String: Any] = ["three": "two", "two": 2, "one": "three"]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentNumberOfStringKeyAnyValuePairsDoNotMatch() {
    // Given
    let firstArgument: [String: Any] = ["one": "one", "two": 2]
    let secondArgument: [String: Any] = ["one": "one", "two": 2, "three": true]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

}


// MARK:- Test cases for `NonOptionalDictionaryMatcher` with Int key


extension MockMatcherTests {

  func testEmptyDictionaryWithIntKeysArgumentsMatch() {
    // Given
    let firstArgument: [Int: Any] = [:]
    let secondArgument: [Int: Any] = [:]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameIntKeysAndSameIntValuesMatch() {
    // Given
    let firstArgument = [1: 1, 2: 2, 3: 3]
    let secondArgument = [1: 1, 2: 2, 3: 3]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameIntKeysAndDifferentIntValuesDoNotMatch() {
    // Given
    let firstArgument = [1: 1, 2: 4, 3: 7]
    let secondArgument = [1: 1, 2: 2, 3: 3]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentIntKeysAndSameIntValuesDoNotMatch() {
    // Given
    let firstArgument = [1: 1, 3: 2, 4: 3]
    let secondArgument = [1: 1, 2: 2, 3: 3]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentIntKeysAndDifferentIntValuesDoNotMatch() {
    // Given
    let firstArgument = [1: 2, 2: 3, 3: 4]
    let secondArgument = [3: 1, 2: 2, 1: 3]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentNumberOfIntKeyIntValuePairsDoNotMatch() {
    // Given
    let firstArgument = [1: 1, 2: 2]
    let secondArgument = [1: 1, 2: 2, 3: 3]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithSameIntKeysAndSameStringValuesMatch() {
    // Given
    let firstArgument = [1: "one", 2: "two", 3: "three"]
    let secondArgument = [1: "one", 2: "two", 3: "three"]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameIntKeysAndDifferentStringValuesDoNotMatch() {
    // Given
    let firstArgument = [1: "one", 2: "two", 3: "three"]
    let secondArgument = [1: "two", 2: "one", 3: "two"]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentIntKeysAndSameStringValuesDoNotMatch() {
    // Given
    let firstArgument = [1: "one", 3: "three", 4: "four"]
    let secondArgument = [1: "one", 2: "three", 3: "four"]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentIntKeysAndDifferentStringValuesDoNotMatch() {
    // Given
    let firstArgument = [1: "one", 2: "three", 3: "two"]
    let secondArgument = [3: "two", 2: "one", 1: "three"]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentNumberOfIntKeyStringValuePairsDoNotMatch() {
    // Given
    let firstArgument = [1: "one", 2: "two"]
    let secondArgument = [1: "one", 2: "two", 3: "three"]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithSameIntKeysAndSameAnyValuesMatch() {
    // Given
    let firstArgument: [Int: Any] = [1: "one", 2: 2, 3: "three"]
    let secondArgument: [Int: Any] = [1: "one", 2: 2, 3: "three"]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameIntKeysAndDifferentAnyValuesDoNotMatch() {
    // Given
    let firstArgument: [Int: Any] = [1: "one", 2: true, 3: 3]
    let secondArgument: [Int: Any] = [1: "two", 2: false, 3: 3]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentIntKeysAndSameAnyValuesDoNotMatch() {
    // Given
    let firstArgument: [Int: Any] = [1: "one", 3: "three", 4: "four"]
    let secondArgument: [Int: Any] = [1: "one", 2: "three", 3: "four"]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentIntKeysAndDifferentAnyValuesDoNotMatch() {
    // Given
    let firstArgument: [Int: Any] = [1: "one", 2: 1, 3: "two"]
    let secondArgument: [Int: Any] = [3: "two", 2: 2, 1: "three"]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentNumberOfIntKeyAnyValuePairsDoNotMatch() {
    // Given
    let firstArgument: [Int: Any] = [1: "one", 2: 2]
    let secondArgument: [Int: Any] = [1: "one", 2: 2, 3: true]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

}


// MARK:- Test cases for `OptionalDictionaryMatcher` with String key


extension MockMatcherTests {

  func testEmptyOptionalDictionaryWithStringKeysArgumentsMatch() {
    // Given
    let firstArgument: [String: Any?] = [:]
    let secondArgument: [String: Any?] = [:]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameStringKeysAndSameOptionalIntValuesMatch() {
    // Given
    let firstArgument: [String: Int?] = ["one": 1, "two": 2, "three": 3, "four": nil]
    let secondArgument: [String: Int?] = ["one": 1, "two": 2, "three": 3, "four": nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameStringKeysAndDifferentOptionalIntValuesDoNotMatch() {
    // Given
    let firstArgument: [String: Int?] = ["one": 1, "two": 4, "three": 7, "four": nil]
    let secondArgument: [String: Int?] = ["one": 1, "two": 2, "three": 3, "four": nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentStringKeysAndSameOptionalIntValuesDoNotMatch() {
    // Given
    let firstArgument: [String: Int?] = ["one": 1, "three": 2, "four": 3, "two": nil]
    let secondArgument: [String: Int?] = ["one": 1, "two": 2, "three": 3, "four": nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentStringKeysAndDifferentOptionalIntValuesDoNotMatch() {
    // Given
    let firstArgument: [String: Int?] = ["one": 2, "two": 3, "three": 4, "four": nil]
    let secondArgument: [String: Int?] = ["three": 1, "two": 2, "one": 3, "four": nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentNumberOfStringKeyOptionalIntValuePairsDoNotMatch() {
    // Given
    let firstArgument: [String: Int?] = ["one": 1, "two": 2, "three": nil]
    let secondArgument: [String: Int?] = ["one": 1, "two": 2, "three": 3, "four": nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithSameStringKeysAndSameOptionalStringValuesMatch() {
    // Given
    let firstArgument: [String: String?] = ["one": "one", "two": "two", "three": "three", "four": nil]
    let secondArgument: [String: String?] = ["one": "one", "two": "two", "three": "three", "four": nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameStringKeysAndDifferentOptionalStringValuesDoNotMatch() {
    // Given
    let firstArgument: [String: String?] = ["one": "one", "two": "two", "three": "three", "four": nil]
    let secondArgument: [String: String?] = ["one": "two", "two": "one", "three": "two", "four": nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentStringKeysAndSameOptionalStringValuesDoNotMatch() {
    // Given
    let firstArgument: [String: String?] = ["one": "one", "three": "three", "four": "four", "two": nil]
    let secondArgument: [String: String?] = ["one": "one", "two": "three", "three": "four", "four": nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentStringKeysAndDifferentOptionalStringValuesDoNotMatch() {
    // Given
    let firstArgument: [String: String?] = ["one": "one", "two": "three", "three": "two", "four": nil]
    let secondArgument: [String: String?] = ["three": "two", "two": "one", "one": "three", "four": nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentNumberOfStringKeyOptionalStringValuePairsDoNotMatch() {
    // Given
    let firstArgument: [String: String?] = ["one": "one", "two": "two", "three": nil]
    let secondArgument: [String: String?] = ["one": "one", "two": "two", "three": "three", "four": nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithSameStringKeysAndSameOptionalAnyValuesMatch() {
    // Given
    let firstArgument: [String: Any?] = ["one": "one", "two": 2, "three": "three", "four": nil]
    let secondArgument: [String: Any?] = ["one": "one", "two": 2, "three": "three", "four": nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameStringKeysAndDifferentOptionalAnyValuesDoNotMatch() {
    // Given
    let firstArgument: [String: Any?] = ["one": "one", "two": true, "three": 3, "four": nil]
    let secondArgument: [String: Any?] = ["one": "two", "two": false, "three": 3, "four": nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentStringKeysAndSameOptionalAnyValuesDoNotMatch() {
    // Given
    let firstArgument: [String: Any?] = ["one": "one", "three": "three", "four": "four", "two": nil]
    let secondArgument: [String: Any?] = ["one": "one", "two": "three", "three": "four", "four": nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentStringKeysAndDifferentOptionalAnyValuesDoNotMatch() {
    // Given
    let firstArgument: [String: Any?] = ["one": "one", "two": 1, "three": "two", "four": nil]
    let secondArgument: [String: Any?] = ["three": "two", "two": 2, "one": "three", "four": nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentNumberOfStringKeyOptionalAnyValuePairsDoNotMatch() {
    // Given
    let firstArgument: [String: Any?] = ["one": "one", "two": 2, "three": nil]
    let secondArgument: [String: Any?] = ["one": "one", "two": 2, "three": true, "four": nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

}


// MARK:- Test cases for `OptionalDictionaryMatcher` with Int key


extension MockMatcherTests {

  func testEmptyOptionalDictionaryWithIntKeysArgumentsMatch() {
    // Given
    let firstArgument: [Int: Any?] = [:]
    let secondArgument: [Int: Any?] = [:]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameIntKeysAndSameOptionalIntValuesMatch() {
    // Given
    let firstArgument: [Int: Int?] = [1: 1, 2: 2, 3: 3, 4: nil]
    let secondArgument: [Int: Int?] = [1: 1, 2: 2, 3: 3, 4: nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameIntKeysAndDifferentOptionalIntValuesDoNotMatch() {
    // Given
    let firstArgument: [Int: Int?] = [1: 1, 2: 4, 3: 7, 4: nil]
    let secondArgument: [Int: Int?] = [1: 1, 2: 2, 3: 3, 4: nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentIntKeysAndSameOptionalIntValuesDoNotMatch() {
    // Given
    let firstArgument: [Int: Int?] = [1: 1, 3: 2, 4: 3, 2: nil]
    let secondArgument: [Int: Int?] = [1: 1, 2: 2, 3: 3, 4: nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentIntKeysAndDifferentOptionalIntValuesDoNotMatch() {
    // Given
    let firstArgument: [Int: Int?] = [1: 2, 2: 3, 3: 4, 4: nil]
    let secondArgument: [Int: Int?] = [3: 1, 2: 2, 1: 3, 4: nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentNumberOfIntKeyOptionalIntValuePairsDoNotMatch() {
    // Given
    let firstArgument: [Int: Int?] = [1: 1, 2: 2, 3: nil]
    let secondArgument: [Int: Int?] = [1: 1, 2: 2, 3: 3, 4: nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithSameIntKeysAndSameOptionalStringValuesMatch() {
    // Given
    let firstArgument: [Int: String?] = [1: "one", 2: "two", 3: "three", 4: nil]
    let secondArgument: [Int: String?] = [1: "one", 2: "two", 3: "three", 4: nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameIntKeysAndDifferentOptionalStringValuesDoNotMatch() {
    // Given
    let firstArgument: [Int: String?] = [1: "one", 2: "two", 3: "three", 4: nil]
    let secondArgument: [Int: String?] = [1: "two", 2: "one", 3: "two", 4: nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentIntKeysAndSameOptionalStringValuesDoNotMatch() {
    // Given
    let firstArgument: [Int: String?] = [1: "one", 3: "three", 4: "four", 2: nil]
    let secondArgument: [Int: String?] = [1: "one", 2: "three", 3: "four", 4: nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentIntKeysAndDifferentOptionalStringValuesDoNotMatch() {
    // Given
    let firstArgument: [Int: String?] = [1: "one", 2: "three", 3: "two", 4: nil]
    let secondArgument: [Int: String?] = [3: "two", 2: "one", 1: "three", 4: nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentNumberOfIntKeyOptionalStringValuePairsDoNotMatch() {
    // Given
    let firstArgument: [Int: String?] = [1: "one", 2: "two", 3: nil]
    let secondArgument: [Int: String?] = [1: "one", 2: "two", 3: "three", 4: nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithSameIntKeysAndSameOptionalAnyValuesMatch() {
    // Given
    let firstArgument: [Int: Any?] = [1: "one", 2: 2, 3: "three", 4: nil]
    let secondArgument: [Int: Any?] = [1: "one", 2: 2, 3: "three", 4: nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertTrue(result)
  }

  func testDictionaryWithSameIntKeysAndDifferentOptionalAnyValuesDoNotMatch() {
    // Given
    let firstArgument: [Int: Any?] = [1: "one", 2: true, 3: 3, 4: nil]
    let secondArgument: [Int: Any?] = [1: "two", 2: false, 3: 3, 4: nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentIntKeysAndSameOptionalAnyValuesDoNotMatch() {
    // Given
    let firstArgument: [Int: Any?] = [1: "one", 3: "three", 4: "four", 2: nil]
    let secondArgument: [Int: Any?] = [1: "one", 2: "three", 3: "four", 4: nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentIntKeysAndDifferentOptionalAnyValuesDoNotMatch() {
    // Given
    let firstArgument: [Int: Any?] = [1: "one", 2: 1, 3: "two", 4: nil]
    let secondArgument: [Int: Any?] = [3: "two", 2: 2, 1: "three", 4: nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

  func testDictionaryWithDifferentNumberOfIntKeyOptionalAnyValuePairsDoNotMatch() {
    // Given
    let firstArgument: [Int: Any?] = [1: "one", 2: 2, 3: nil]
    let secondArgument: [Int: Any?] = [1: "one", 2: 2, 3: true, 4: nil]

    let sut = mockMatcher

    // When
    let result = sut.match(arguments: firstArgument, withArguments: secondArgument)

    // Then
    XCTAssertFalse(result)
  }

}
