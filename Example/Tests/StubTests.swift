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

  func testCallWithNonNilReturnValueCreatesActionable() {
    // Given
    let sut = stub

    // When
    let actionable = sut?.call(withReturnValue: 13)

    // Then
    XCTAssertNotNil(actionable)
  }

  func testCallWithVoidReturnValueCreatesActionable() {
    // Given
    let sut = stub

    // When
    let actionable = sut?.call(withReturnValue: ())

    // Then
    XCTAssertNotNil(actionable)
  }

  func testCallWithNilReturnValueCreatesActionable() {
    // Given
    let sut = stub

    // When
    let actionable: Actionable<Any?> = sut!.call(withReturnValue: nil)

    // Then
    XCTAssertNotNil(actionable)
  }

  func testCallDoesNotMatchStubRegistrationWithDifferentFunctionName() {
    // Given
    let sut = stub

    let expectedFunctionName = "func"
    let args: [Any?] = [1, "one", true, nil]

    let actualFunctionName = "banana"

    // When
    sut?.acceptStub(withFunctionName: expectedFunctionName, andExpectedArgs: args)
    let matched = (sut?.satisfyStub(withFunctionName: actualFunctionName))! && (sut?.satisfyStub(withActualArgs: args))!

    // Then
    XCTAssertFalse(matched)
  }

  func testCallDoesNotMatchStubRegistrationWithDifferentArgumentCount() {
    // Given
    let sut = stub

    let functionName = "func"
    let expectedArgs: [Any?] = [1, "one", true]

    let actualArgs: [Any?] = [1, "one"]

    // When
    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: expectedArgs)
    let matched = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: actualArgs))!

    // Then
    XCTAssertFalse(matched)
  }

  func testCallDoesNotMatchStubRegistrationWithDifferentArgumentsExpectingNilReceivingNotNil() {
    // Given
    let sut = stub

    let functionName = "func"
    let expectedArgs: [Any?] = ["one", nil, true]

    let actualArgs: [Any?] = ["one", 3, true]

    // When
    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: expectedArgs)
    let matched = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: actualArgs))!

    // Then
    XCTAssertFalse(matched)
  }

  func testCallDoesNotMatchStubRegistrationWithDifferentArgumentsExpectingNotNilReceivingNil() {
    // Given
    let sut = stub

    let functionName = "func"
    let expectedArgs: [Any?] = ["one", 3, true]

    let actualArgs: [Any?] = ["one", nil, true]

    // When
    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: expectedArgs)
    let matched = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: actualArgs))!

    // Then
    XCTAssertFalse(matched)
  }

  func testCallDoesNotMatchStubRegistrationWithDifferentNonNilArgumentTypes() {
    // Given
    let sut = stub

    let functionName = "func"
    let expectedArgs: [Any?] = ["one", 2, true]

    let actualArgs: [Any?] = ["one", "bob", true]

    // When
    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: expectedArgs)
    let matched = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: actualArgs))!

    // Then
    XCTAssertFalse(matched)
  }

  func testCallDoesNotMatchStubRegistrationWithDifferentNonNilArguments() {
    // Given
    let sut = stub

    let functionName = "func"
    let expectedArgs: [Any?] = ["one", 2, true]

    let actualArgs: [Any?] = ["one", 3, true]

    // When
    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: expectedArgs)
    let matched = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: actualArgs))!

    // Then
    XCTAssertFalse(matched)
  }

  func testCallMatchesStubRegistrationWithoutArgumentMatcher() {
    // Given
    let sut = stub

    let functionName = "func"
    let args: [Any?] = [1, "one", true, nil]

    // When
    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: args)
    let matched = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!

    // Then
    XCTAssertTrue(matched)
  }

  func testCallMatchesStubRegistrationWithAnythingAsNonOptionalArgumentMatcher() {
    // Given
    let sut = stub

    let functionName = "func"
    let expectedArgs: [Any?] = [1, "one", true]
    let actualArgs: [Any?] = [AnyValue.int, AnyValue.string, AnyValue.bool]

    // When
    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: expectedArgs)
    let _ = sut?.call(withReturnValue: 13, andArgumentMatching: [Anything(), Anything(), Anything()])

    let matched = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: actualArgs))!

    // Then
    XCTAssertTrue(matched)
  }

  func testCallDoesNotMatchStubRegistrationWithAnyValueAsActualArgAndExactAsArgumentMatcher() {
    // Given
    let sut = stub

    let functionName = "func"
    let expectedArgs: [Any?] = [1, "one", true]
    let actualArgs: [Any?] = [AnyValue.int, AnyValue.string, AnyValue.bool]

    // When
    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: expectedArgs)
    let _ = sut?.call(withReturnValue: 13, andArgumentMatching: [Exact(), Exact(), Exact()])

    let matched = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: actualArgs))!

    // Then
    XCTAssertFalse(matched)
  }

  func testCallMatchesStubRegistrationWithAnythingAndExactAsNonOptionalArgumentMatcher() {
    // Given
    let sut = stub

    let functionName = "func"
    let expectedArgs: [Any?] = [1, "one", true]
    let actualArgs: [Any?] = [AnyValue.int, "one", AnyValue.bool]

    // When
    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: expectedArgs)
    let _ = sut?.call(withReturnValue: 13, andArgumentMatching: [Anything(), Exact(), Anything()])

    let matched = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: actualArgs))!

    // Then
    XCTAssertTrue(matched)
  }

  func testCallDoesNotMatchStubRegistrationWithAnythingAndExactAsNonOptionalArgumentMatcher() {
    // Given
    let sut = stub

    let functionName = "func"
    let expectedArgs: [Any?] = [1, "one", true]
    let actualArgs: [Any?] = [AnyValue.int, "one", AnyValue.bool]

    // When
    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: expectedArgs)
    let _ = sut?.call(withReturnValue: 13, andArgumentMatching: [Exact(), Anything(), Exact()])

    let matched = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: actualArgs))!

    // Then
    XCTAssertFalse(matched)
  }

  func testCallMatchesStubRegistrationWithAnythingAndExactAsOptionalArgumentMatcher() {
    // Given
    let sut = stub

    let functionName = "func"
    let expectedArgs: [Any?] = [1, "one", true, nil]
    let actualArgs: [Any?] = [AnyValue.int, "one", AnyValue.bool, nil]

    // When
    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: expectedArgs)
    let _ = sut?.call(withReturnValue: 13, andArgumentMatching: [Anything(), Exact(), Anything(), Exact()])

    let matched = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: actualArgs))!

    // Then
    XCTAssertTrue(matched)
  }

  func testCallDoesNotMatchStubRegistrationWithAnythingAndExactAsOptionalArgumentMatcher() {
    // Given
    let sut = stub

    let functionName = "func"
    let expectedArgs: [Any?] = [1, "one", true, nil]
    let actualArgs: [Any?] = [AnyValue.int, AnyValue.string, AnyValue.bool, nil]

    // When
    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: expectedArgs)
    let _ = sut?.call(withReturnValue: 13, andArgumentMatching: [Exact(), Anything(), Exact(), Exact()])

    let matched = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: actualArgs))!

    // Then
    XCTAssertFalse(matched)
  }

}


// MARK:- Test cases for `Stub` actionable thenReturn


extension StubTests {

  func testCallingStubWithNoActionsReturnsDummyReturnValue() {
    // Given
    let sut = stub

    let dummyReturnValue = 13

    // When
    let actionable = sut?.call(withReturnValue: dummyReturnValue)
    let returnValue = actionable?.performActions() as! Int

    // Then
    XCTAssertEqual(returnValue, dummyReturnValue)
  }

  func testCallingStubOnceWithSuccessfulArgumentMatchingThenReturnValue() {
    // Given
    let sut = stub

    let functionName = "func"
    let args: [Any?] = [1, "one", true, nil]
    let dummyReturnValue = 13

    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: args)
    let actionable = sut?.call(withReturnValue: dummyReturnValue).thenReturn(42)

    // When
    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValue = actionable?.performActions() as! Int

    // Then
    XCTAssertEqual(returnValue, 42)
  }

  func testCallingStubMultipleTimesWithSuccessfulArgumentMatchingThenReturnLastValueForNonCorrespondingCalls() {
    // Given
    let sut = stub

    let functionName = "func"
    let args: [Any?] = [1, "one", true, nil]
    let dummyReturnValue = 13

    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: args)
    let actionable = sut?.call(withReturnValue: dummyReturnValue).thenReturn(42)

    // When
    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfFirstCall = actionable?.performActions() as! Int

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfSecondCall = actionable?.performActions() as! Int

    // Then
    XCTAssertEqual(returnValueOfFirstCall, 42)
    XCTAssertEqual(returnValueOfSecondCall, 42)
  }

  func testCallingStubMultipleTimesWithSuccessfulArgumentMatchingThenReturnCorrespondingValues() {
    // Given
    let sut = stub

    let functionName = "func"
    let args: [Any?] = [1, "one", true, nil]
    let dummyReturnValue = 13

    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: args)
    let actionable = sut?.call(withReturnValue: dummyReturnValue).thenReturn(42, 17, 18)

    // When
    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfFirstCall = actionable?.performActions() as! Int

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfSecondCall = actionable?.performActions() as! Int

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfThirdCall = actionable?.performActions() as! Int

    // Then
    XCTAssertEqual(returnValueOfFirstCall, 42)
    XCTAssertEqual(returnValueOfSecondCall, 17)
    XCTAssertEqual(returnValueOfThirdCall, 18)
  }

  func testCallingStubMultipleTimesWithSuccessfulArgumentMatchingInSomeCallsThenReturnCorrespondingValues() {
    // Given
    let sut = stub

    let functionName = "func"
    let args: [Any?] = [1, "one", true, nil]
    let dummyReturnValue = 13

    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: args)
    let actionable = sut?.call(withReturnValue: dummyReturnValue).thenReturn(42, 17, 18)

    // When
    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfFirstCall = actionable?.performActions() as! Int

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: [2, "two", true, nil]))!

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfThirdCall = actionable?.performActions() as! Int

    // Then
    XCTAssertEqual(returnValueOfFirstCall, 42)
    XCTAssertEqual(returnValueOfThirdCall, 18)
  }

  func testCallingStubMultipleTimesWithSuccessfulArgumentMatchingInSomeCallsThenReturnLastValueForNonCorrespondingCalls() {
    // Given
    let sut = stub

    let functionName = "func"
    let args: [Any?] = [1, "one", true, nil]
    let dummyReturnValue = 13

    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: args)
    let actionable = sut?.call(withReturnValue: dummyReturnValue).thenReturn(42, 17, 18)

    // When
    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfFirstCall = actionable?.performActions() as! Int

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfSecondCall = actionable?.performActions() as! Int

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: [2, "two", true, nil]))!

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfFourthCall = actionable?.performActions() as! Int

    // Then
    XCTAssertEqual(returnValueOfFirstCall, 42)
    XCTAssertEqual(returnValueOfSecondCall, 17)
    XCTAssertEqual(returnValueOfFourthCall, 18)
  }

}


// MARK:- Test cases for `Stub` actionable thenDo


extension StubTests {

  func testCallingStubOnceWithSuccessfulArgumentMatchingThenDoAction() {
    // Given
    let sut = stub

    let functionName = "func"
    let args: [Any?] = [1, "one", true, nil]
    let dummyReturnValue = 13

    var flag = false

    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: args)
    let actionable = sut?.call(withReturnValue: dummyReturnValue).thenDo {
      (args: [Any?]) -> Void in

      flag = true
    }

    // When
    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValue = actionable?.performActions()

    // Then
    XCTAssertNil(returnValue)
    XCTAssertTrue(flag)
  }

  func testCallingStubMultipleTimesWithSuccessfulArgumentMatchingThenDoLastActionForNonCorrespondingCalls() {
    // Given
    let sut = stub

    let functionName = "func"
    let args: [Any?] = [1, "one", true, nil]
    let dummyReturnValue = 13

    var array = [Bool]()

    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: args)
    let actionable = sut?.call(withReturnValue: dummyReturnValue).thenDo {
      (args: [Any?]) -> Void in

      array.append(true)
    }

    // When
    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfFirstCall = actionable?.performActions()

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfSecondCall = actionable?.performActions()

    // Then
    XCTAssertNil(returnValueOfFirstCall)
    XCTAssertNil(returnValueOfSecondCall)

    XCTAssertEqual(array.count, 2)
  }

  func testCallingStubMultipleTimesWithSuccessfulArgumentMatchingThenDoCorrespondingActions() {
    // Given
    let sut = stub

    let functionName = "func"
    let args: [Any?] = [1, "one", true, nil]
    let dummyReturnValue = 13

    var array = [0, 0, 0]

    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: args)
    let actionable = sut?.call(withReturnValue: dummyReturnValue).thenDo {
      (args: [Any?]) -> Void in

      array[0] = 1
    }.thenDo {
      (args: [Any?]) -> Void in

      array[1] = 2
    }.thenDo {
      (args: [Any?]) -> Void in

      array[2] = 3
    }

    // When
    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfFirstCall = actionable?.performActions()

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfSecondCall = actionable?.performActions()

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfThirdCall = actionable?.performActions()

    // Then
    XCTAssertNil(returnValueOfFirstCall)
    XCTAssertEqual(array[0], 1)

    XCTAssertNil(returnValueOfSecondCall)
    XCTAssertEqual(array[1], 2)

    XCTAssertNil(returnValueOfThirdCall)
    XCTAssertEqual(array[2], 3)
  }

  func testCallingStubMultipleTimesWithSuccessfulArgumentMatchingInSomeCallsThenDoCorrespondingActions() {
    // Given
    let sut = stub

    let functionName = "func"
    let args: [Any?] = [1, "one", true, nil]
    let dummyReturnValue = 13

    var array = [0, 0, 0]

    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: args)
    let actionable = sut?.call(withReturnValue: dummyReturnValue).thenDo {
      (args: [Any?]) -> Void in

      array[0] = 1
    }.thenDo {
      (args: [Any?]) -> Void in

      array[1] = 2
    }.thenDo {
      (args: [Any?]) -> Void in

      array[2] = 3
    }

    // When
    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfFirstCall = actionable?.performActions()

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: [2, "two", true, nil]))!

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfThirdCall = actionable?.performActions()

    // Then
    XCTAssertNil(returnValueOfFirstCall)
    XCTAssertEqual(array[0], 1)

    XCTAssertEqual(array[1], 0)

    XCTAssertNil(returnValueOfThirdCall)
    XCTAssertEqual(array[2], 3)
  }

  func testCallingStubMultipleTimesWithSuccessfulArgumentMatchingInSomeCallsThenDoLastActionForNonCorrespondingCalls() {
    // Given
    let sut = stub

    let functionName = "func"
    let args: [Any?] = [1, "one", true, nil]
    let dummyReturnValue = 13

    var array = [Bool]()

    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: args)
    let actionable = sut?.call(withReturnValue: dummyReturnValue).thenDo {
      (args: [Any?]) -> Void in

      array.append(true)
    }.thenDo {
      (args: [Any?]) -> Void in

      array.append(true)
    }.thenDo {
      (args: [Any?]) -> Void in

      array.append(true)
    }

    // When
    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfFirstCall = actionable?.performActions()

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfSecondCall = actionable?.performActions()

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: [2, "two", true, nil]))!

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfFourthCall = actionable?.performActions()

    // Then
    XCTAssertNil(returnValueOfFirstCall)
    XCTAssertNil(returnValueOfSecondCall)
    XCTAssertNil(returnValueOfFourthCall)

    XCTAssertEqual(array.count, 3)
  }

}


// MARK:- Test cases for `Stub` actionable thenAnswer


extension StubTests {

  func testCallingStubOnceWithSuccessfulArgumentMatchingThenAnswerValue() {
    // Given
    let sut = stub

    let functionName = "func"
    let args: [Any?] = [1, "one", true, nil]
    let dummyReturnValue = 13

    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: args)
    let actionable = sut?.call(withReturnValue: dummyReturnValue).thenAnswer {
      (args: [Any?]) -> Int in

      return (args[0] as! Int) * 2
    }

    // When
    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValue = actionable?.performActions() as! Int

    // Then
    XCTAssertEqual(returnValue, 2)
  }

  func testCallingStubMultipleTimesWithSuccessfulArgumentMatchingThenAnswerLastValueForNonCorrespondingCalls() {
    // Given
    let sut = stub

    let functionName = "func"
    let args: [Any?] = [2, "one", true, nil]
    let dummyReturnValue = 13

    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: args)
    let actionable = sut?.call(withReturnValue: dummyReturnValue).thenAnswer {
      (args: [Any?]) -> Int in

      return (args[0] as! Int) * 2
    }

    // When
    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfFirstCall = actionable?.performActions() as! Int

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfSecondCall = actionable?.performActions() as! Int

    // Then
    XCTAssertEqual(returnValueOfFirstCall, 4)
    XCTAssertEqual(returnValueOfSecondCall, 4)
  }

  func testCallingStubMultipleTimesWithSuccessfulArgumentMatchingThenAnswerCorrespondingValues() {
    // Given
    let sut = stub

    let functionName = "func"
    let args: [Any?] = [2, "one", true, nil]
    let dummyReturnValue = 13

    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: args)
    let actionable = sut?.call(withReturnValue: dummyReturnValue).thenAnswer {
      (args: [Any?]) -> Int in

      return (args[0] as! Int) * 2
    }.thenAnswer {
      (args: [Any?]) -> Int in

      return (args[0] as! Int) * 3
    }.thenAnswer {
      (args: [Any?]) -> Int in

      return (args[0] as! Int) * 4
    }

    // When
    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfFirstCall = actionable?.performActions() as! Int

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfSecondCall = actionable?.performActions() as! Int

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfThirdCall = actionable?.performActions() as! Int

    // Then
    XCTAssertEqual(returnValueOfFirstCall, 4)
    XCTAssertEqual(returnValueOfSecondCall, 6)
    XCTAssertEqual(returnValueOfThirdCall, 8)
  }

  func testCallingStubMultipleTimesWithSuccessfulArgumentMatchingInSomeCallsThenAnswerCorrespondingValues() {
    // Given
    let sut = stub

    let functionName = "func"
    let args: [Any?] = [2, "one", true, nil]
    let dummyReturnValue = 13

    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: args)
    let actionable = sut?.call(withReturnValue: dummyReturnValue).thenAnswer {
      (args: [Any?]) -> Int in

      return (args[0] as! Int) * 2
    }.thenAnswer {
      (args: [Any?]) -> Int in

      return (args[0] as! Int) * 3
    }.thenAnswer {
      (args: [Any?]) -> Int in

      return (args[0] as! Int) * 4
    }

    // When
    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfFirstCall = actionable?.performActions() as! Int

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: [2, "two", true, nil]))!

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfThirdCall = actionable?.performActions() as! Int

    // Then
    XCTAssertEqual(returnValueOfFirstCall, 4)
    XCTAssertEqual(returnValueOfThirdCall, 8)
  }

  func testCallingStubMultipleTimesWithSuccessfulArgumentMatchingInSomeCallsThenAnswerLastValueForNonCorrespondingCalls() {
    // Given
    let sut = stub

    let functionName = "func"
    let args: [Any?] = [2, "one", true, nil]
    let dummyReturnValue = 13

    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: args)
    let actionable = sut?.call(withReturnValue: dummyReturnValue).thenAnswer {
      (args: [Any?]) -> Int in

      return (args[0] as! Int) * 2
    }.thenAnswer {
      (args: [Any?]) -> Int in

      return (args[0] as! Int) * 3
    }.thenAnswer {
      (args: [Any?]) -> Int in

      return (args[0] as! Int) * 4
    }

    // When
    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfFirstCall = actionable?.performActions() as! Int

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfSecondCall = actionable?.performActions() as! Int

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: [2, "two", true, nil]))!

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfFourthCall = actionable?.performActions() as! Int

    // Then
    XCTAssertEqual(returnValueOfFirstCall, 4)
    XCTAssertEqual(returnValueOfSecondCall, 6)
    XCTAssertEqual(returnValueOfFourthCall, 8)
  }

}


// MARK:- Test cases for `Stub` actionable chaining


extension StubTests {

  func testCallingStubByChainingDifferentActionablesIncludingSingleThenReturn() {
    // Given
    let sut = stub

    let functionName = "func"
    let args: [Any?] = [2, "one", true, nil]
    let dummyReturnValue = 13

    var flag = false

    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: args)
    let actionable = sut?.call(withReturnValue: dummyReturnValue).thenReturn(42).thenDo {
      (args: [Any?]) -> Void in

      flag = true
    }.thenAnswer {
      (args: [Any?]) -> Int in

      return (args[0] as! Int) * 2
    }

    // When
    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfFirstCall = actionable?.performActions() as! Int

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfSecondCall = actionable?.performActions()

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfThirdCall = actionable?.performActions() as! Int

    // Then
    XCTAssertEqual(returnValueOfFirstCall, 42)

    XCTAssertNil(returnValueOfSecondCall)
    XCTAssertTrue(flag)

    XCTAssertEqual(returnValueOfThirdCall, 4)
  }

  func testCallingStubByChainingDifferentActionablesIncludingMultipleThenReturn() {
    // Given
    let sut = stub

    let functionName = "func"
    let args: [Any?] = [2, "one", true, nil]
    let dummyReturnValue = 13

    var flag = false

    sut?.acceptStub(withFunctionName: functionName, andExpectedArgs: args)
    let actionable = sut?.call(withReturnValue: dummyReturnValue).thenDo {
      (args: [Any?]) -> Void in

      flag = true
    }.thenReturn(42, 17).thenAnswer {
      (args: [Any?]) -> Int in

      return (args[0] as! Int) * 2
    }

    // When
    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfFirstCall = actionable?.performActions()

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfSecondCall = actionable?.performActions() as! Int

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfThirdCall = actionable?.performActions() as! Int

    let _ = (sut?.satisfyStub(withFunctionName: functionName))! && (sut?.satisfyStub(withActualArgs: args))!
    let returnValueOfFourthCall = actionable?.performActions() as! Int

    // Then
    XCTAssertNil(returnValueOfFirstCall)
    XCTAssertTrue(flag)

    XCTAssertEqual(returnValueOfSecondCall, 42)
    XCTAssertEqual(returnValueOfThirdCall, 17)

    XCTAssertEqual(returnValueOfFourthCall, 4)
  }

}
