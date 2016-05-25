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


// MARK:- Test cases for `Stub` registration and satisfaction during actual call


class StubTests: XCTestCase {

  var stub: Stub!

  override func setUp() {
    stub = Stub()
  }

  func testCallCreatesActionable() {
    //Given
    let sut = stub

    //When
    let actionable = sut.call(withReturnValue: 13)

    //Then
    XCTAssertNotNil(actionable)
  }

  func testCallDoesNotMatchStubRegistrationWithDifferentFunctionName() {
    //Given
    let sut = stub

    let expectedFunctionName = "func"
    let args: [Any?] = [1, "one", true, nil]

    let actualFunctionName = "banana"

    //When
    sut.acceptStub(withFunctionName: expectedFunctionName, andExpectedArgs: args)
    let matched = sut.satisfyStub(withFunctionName: actualFunctionName) && sut.satisfyStub(withActualArgs: args)

    //Then
    XCTAssertFalse(matched)
  }

  func testCallDoesNotMatchStubRegistrationWithDifferentArgumentCount() {
    //Given
    let sut = stub

    let functionName = "func"
    let expectedArgs: [Any?] = [1, "one", true]

    let actualArgs: [Any?] = [1, "one"]

    //When
    sut.acceptStub(withFunctionName: functionName, andExpectedArgs: expectedArgs)
    let matched = sut.satisfyStub(withFunctionName: functionName) && sut.satisfyStub(withActualArgs: actualArgs)

    //Then
    XCTAssertFalse(matched)
  }

  func testCallDoesNotMatchStubRegistrationWithDifferentArgumentsExpectingNilReceivingNotNil() {
    //Given
    let sut = stub

    let functionName = "func"
    let expectedArgs: [Any?] = ["one", nil, true]

    let actualArgs: [Any?] = ["one", 3, true]

    //When
    sut.acceptStub(withFunctionName: functionName, andExpectedArgs: expectedArgs)
    let matched = sut.satisfyStub(withFunctionName: functionName) && sut.satisfyStub(withActualArgs: actualArgs)

    //Then
    XCTAssertFalse(matched)
  }

  func testCallDoesNotMatchStubRegistrationWithDifferentArgumentsExpectingNotNilReceivingNil() {
    //Given
    let sut = stub

    let functionName = "func"
    let expectedArgs: [Any?] = ["one", 3, true]

    let actualArgs: [Any?] = ["one", nil, true]

    //When
    sut.acceptStub(withFunctionName: functionName, andExpectedArgs: expectedArgs)
    let matched = sut.satisfyStub(withFunctionName: functionName) && sut.satisfyStub(withActualArgs: actualArgs)

    //Then
    XCTAssertFalse(matched)
  }

  func testCallDoesNotMatchStubRegistrationWithDifferentNonNilArgumentTypes() {
    //Given
    let sut = stub

    let functionName = "func"
    let expectedArgs: [Any?] = ["one", 2, true]

    let actualArgs: [Any?] = ["one", "bob", true]

    //When
    sut.acceptStub(withFunctionName: functionName, andExpectedArgs: expectedArgs)
    let matched = sut.satisfyStub(withFunctionName: functionName) && sut.satisfyStub(withActualArgs: actualArgs)

    //Then
    XCTAssertFalse(matched)
  }

  func testCallDoesNotMatchStubRegistrationWithDifferentNonNilArguments() {
    //Given
    let sut = stub

    let functionName = "func"
    let expectedArgs: [Any?] = ["one", 2, true]

    let actualArgs: [Any?] = ["one", 3, true]

    //When
    sut.acceptStub(withFunctionName: functionName, andExpectedArgs: expectedArgs)
    let matched = sut.satisfyStub(withFunctionName: functionName) && sut.satisfyStub(withActualArgs: actualArgs)

    //Then
    XCTAssertFalse(matched)
  }

  func testCallMatchesStubRegistrationWithoutArgumentMatcher() {
    //Given
    let sut = stub

    let functionName = "func"
    let args: [Any?] = [1, "one", true, nil]

    //When
    sut.acceptStub(withFunctionName: functionName, andExpectedArgs: args)
    let matched = sut.satisfyStub(withFunctionName: functionName) && sut.satisfyStub(withActualArgs: args)

    //Then
    XCTAssertTrue(matched)
  }

  func testCallMatchesStubRegistrationWithAnythingAsNonOptionalArgumentMatcher() {
    //Given
    let sut = stub

    let functionName = "func"
    let expectedArgs: [Any?] = [1, "one", true]
    let actualArgs: [Any?] = [AnyValue.int, AnyValue.string, AnyValue.bool]

    //When
    sut.acceptStub(withFunctionName: functionName, andExpectedArgs: expectedArgs)
    sut.call(withReturnValue: 13, andArgumentMatching: [Anything(), Anything(), Anything()])

    let matched = sut.satisfyStub(withFunctionName: functionName) && sut.satisfyStub(withActualArgs: actualArgs)

    //Then
    XCTAssertTrue(matched)
  }

  func testCallDoesNotMatchStubRegistrationWithAnyValueAsActualArgAndExactAsArgumentMatcher() {
    //Given
    let sut = stub

    let functionName = "func"
    let expectedArgs: [Any?] = [1, "one", true]
    let actualArgs: [Any?] = [AnyValue.int, AnyValue.string, AnyValue.bool]

    //When
    sut.acceptStub(withFunctionName: functionName, andExpectedArgs: expectedArgs)
    sut.call(withReturnValue: 13, andArgumentMatching: [Exact(), Exact(), Exact()])

    let matched = sut.satisfyStub(withFunctionName: functionName) && sut.satisfyStub(withActualArgs: actualArgs)

    //Then
    XCTAssertFalse(matched)
  }

  func testCallMatchesStubRegistrationWithAnythingAndExactAsNonOptionalArgumentMatcher() {
    //Given
    let sut = stub

    let functionName = "func"
    let expectedArgs: [Any?] = [1, "one", true]
    let actualArgs: [Any?] = [AnyValue.int, "one", AnyValue.bool]

    //When
    sut.acceptStub(withFunctionName: functionName, andExpectedArgs: expectedArgs)
    sut.call(withReturnValue: 13, andArgumentMatching: [Anything(), Exact(), Anything()])

    let matched = sut.satisfyStub(withFunctionName: functionName) && sut.satisfyStub(withActualArgs: actualArgs)

    //Then
    XCTAssertTrue(matched)
  }

  func testCallDoesNotMatchStubRegistrationWithAnythingAndExactAsNonOptionalArgumentMatcher() {
    //Given
    let sut = stub

    let functionName = "func"
    let expectedArgs: [Any?] = [1, "one", true]
    let actualArgs: [Any?] = [AnyValue.int, "one", AnyValue.bool]

    //When
    sut.acceptStub(withFunctionName: functionName, andExpectedArgs: expectedArgs)
    sut.call(withReturnValue: 13, andArgumentMatching: [Exact(), Anything(), Exact()])

    let matched = sut.satisfyStub(withFunctionName: functionName) && sut.satisfyStub(withActualArgs: actualArgs)

    //Then
    XCTAssertFalse(matched)
  }

  func testCallMatchesStubRegistrationWithAnythingAndExactAsOptionalArgumentMatcher() {
    //Given
    let sut = stub

    let functionName = "func"
    let expectedArgs: [Any?] = [1, "one", true, nil]
    let actualArgs: [Any?] = [AnyValue.int, "one", AnyValue.bool, nil]

    //When
    sut.acceptStub(withFunctionName: functionName, andExpectedArgs: expectedArgs)
    sut.call(withReturnValue: 13, andArgumentMatching: [Anything(), Exact(), Anything(), Exact()])

    let matched = sut.satisfyStub(withFunctionName: functionName) && sut.satisfyStub(withActualArgs: actualArgs)

    //Then
    XCTAssertTrue(matched)
  }

  func testCallDoesNotMatchStubRegistrationWithAnythingAndExactAsOptionalArgumentMatcher() {
    //Given
    let sut = stub

    let functionName = "func"
    let expectedArgs: [Any?] = [1, "one", true, nil]
    let actualArgs: [Any?] = [AnyValue.int, AnyValue.string, AnyValue.bool, nil]

    //When
    sut.acceptStub(withFunctionName: functionName, andExpectedArgs: expectedArgs)
    sut.call(withReturnValue: 13, andArgumentMatching: [Exact(), Anything(), Exact(), Exact()])

    let matched = sut.satisfyStub(withFunctionName: functionName) && sut.satisfyStub(withActualArgs: actualArgs)

    //Then
    XCTAssertFalse(matched)
  }
}