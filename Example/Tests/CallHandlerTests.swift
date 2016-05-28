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


// MARK:- An implementation of `Mock` protocol


class MockImplementation: Mock {

  var callHandler: CallHandler

  init(withCallHandler callHandler: CallHandler) {
    self.callHandler = callHandler
  }

  func doSomethingWithNonOptionalArguments(arg1: String, arg2: Int) -> Int {
    return callHandler.accept(0, ofFunction: #function, atFile: #file, inLine: #line, withArgs: arg1, arg2) as! Int
  }

  func doSomethingWithNoArguments() {
    callHandler.accept(nil, ofFunction: #function, atFile: #file, inLine: #line, withArgs: nil)
  }

  func doSomethingWithSomeOptionalArguments(arg1: String?, arg2: Int) {
    callHandler.accept(nil, ofFunction: #function, atFile: #file, inLine: #line, withArgs: arg1, arg2)
  }
}


// MARK:- A test implementation of `MockFailer` protocol


class Failer: MockFailer {

  var message: String?
  var file: String?
  var line: UInt?

  func doFail(message: String, file: String, line: UInt) {
    self.message = message
    self.file = file
    self.line = line
  }
}


// MARK:- CallHandlerTests setup


class CallHandlerTests: XCTestCase {

  var mockImplementation: MockImplementation!
  let failer = Failer()
  var sut: CallHandlerImpl!

  override func setUp() {
    sut = CallHandlerImpl(withFailer: failer)
    mockImplementation = MockImplementation(withCallHandler: sut)
  }
}


// MARK:- Test cases for CallHandler state `When`


extension CallHandlerTests {

  func testCallingStubOnceWithNonOptionalArgumentsReturnsValueByPerformingActionsOnSuccessfulStubMatching() {
    //Given
    mockImplementation.when().call(withReturnValue: mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)).thenReturn(42)

    //When
    let returnValue = mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)

    //Then
    XCTAssertEqual(returnValue, 42)
  }

  func testCallingStubMultipleTimesWithNonOptionalArgumentsReturnsValueByPerformingActionsOnSuccessfulStubMatching() {
    //Given
    mockImplementation.when().call(withReturnValue: mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)).thenReturn(42, 18)

    //When
    let returnValueOfFirstCall = mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)
    let returnValueOfSecondCall = mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)

    //Then
    XCTAssertEqual(returnValueOfFirstCall, 42)
    XCTAssertEqual(returnValueOfSecondCall, 18)
  }

  func testCallingStubOnceWithOptionalArgumentsReturnsValueByPerformingActionsOnSuccessfulStubMatching() {
    //Given
    var flag = false

    mockImplementation.when().call(withReturnValue: mockImplementation.doSomethingWithSomeOptionalArguments(nil, arg2: 1)).thenDo({
      (args: [Any?]) -> Void in

      flag = true
    })

    //When
    mockImplementation.doSomethingWithSomeOptionalArguments(nil, arg2: 1)

    //Then
    XCTAssertTrue(flag)
  }

  func testCallingStubMultipleTimesWithOptionalArgumentsReturnsValueByPerformingActionsOnSuccessfulStubMatching() {
    //Given
    var array = [0, 0]

    mockImplementation.when().call(withReturnValue: mockImplementation.doSomethingWithSomeOptionalArguments(nil, arg2: 1)).thenDo({
      (args: [Any?]) -> Void in

      array[0] = 1
    }).thenDo({
      (args: [Any?]) -> Void in

      array[1] = 2
    })

    //When
    mockImplementation.doSomethingWithSomeOptionalArguments(nil, arg2: 1)
    mockImplementation.doSomethingWithSomeOptionalArguments(nil, arg2: 1)

    //Then
    XCTAssertEqual(array[0], 1)
    XCTAssertEqual(array[1], 2)
  }

  func testCallingStubReturnsDefaultValueOnUnsuccessfulStubMatching() {
    //Given
    mockImplementation.when().call(withReturnValue: mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)).thenReturn(42)

    //When
    let returnValue = mockImplementation.doSomethingWithNonOptionalArguments("two", arg2: 1)

    //Then
    XCTAssertEqual(returnValue, 0)
  }

  func testCallingMethodForWhichNoStubIsRegisteredReturnsDefaultValue() {
    //Given

    //When
    let returnValue = mockImplementation.doSomethingWithNonOptionalArguments("two", arg2: 1)

    //Then
    XCTAssertEqual(returnValue, 0)
  }
}


// MARK:- Test cases for CallHandler state `Verify`


extension CallHandlerTests {

  func testVerificationModeOnceSucceedsWhenMethodIsCalledOnce() {
    //Given
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)

    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)

    //When
    (mockImplementation.verify(verificationMode: Once()) as!
      MockImplementation).doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int)

    //Then
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)
  }

  func testVerificationModeOnceFailsWhenMethodIsCalledMoreThanOnce() {
    //Given
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)

    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)
    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)

    //When
    (mockImplementation.verify(verificationMode: Once()) as!
      MockImplementation).doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int)

    //Then
    XCTAssertNotNil(failer.message)
    XCTAssertNotNil(failer.file)
    XCTAssertNotNil(failer.line)
  }

  func testVerificationModeAtLeastOnceSucceedsWhenMethodIsCalledOnce() {
    //Given
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)

    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)

    //When
    (mockImplementation.verify(verificationMode: AtLeastOnce()) as!
      MockImplementation).doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int)

    //Then
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)
  }

  func testVerificationModeAtLeastOnceSucceedsWhenMethodIsCalledMoreThanOnce() {
    //Given
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)

    mockImplementation.doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int)
    mockImplementation.doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int)

    //When
    (mockImplementation.verify(verificationMode: AtLeastOnce()) as!
      MockImplementation).doSomethingWithNonOptionalArguments("one", arg2: 1)

    //Then
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)
  }

  func testVerificationModeAtLeastOnceFailsWhenMethodIsCalledLessThanOnce() {
    //Given
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)

    //When
    (mockImplementation.verify(verificationMode: AtLeastOnce()) as!
      MockImplementation).doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int)

    //Then
    XCTAssertNotNil(failer.message)
    XCTAssertNotNil(failer.file)
    XCTAssertNotNil(failer.line)
  }

  func testVerificationModeAtMostOnceSucceedsWhenMethodIsCalledOnce() {
    //Given
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)

    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)

    //When
    (mockImplementation.verify(verificationMode: AtMostOnce()) as!
      MockImplementation).doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int)

    //Then
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)
  }

  func testVerificationModeAtMostOnceSucceedsWhenMethodIsCalledLessThanOnce() {
    //Given
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)

    //When
    (mockImplementation.verify(verificationMode: AtMostOnce()) as!
      MockImplementation).doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int)

    //Then
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)
  }

  func testVerificationModeAtMostOnceFailsWhenMethodIsCalledMoreThanOnce() {
    //Given
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)

    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)
    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)

    //When
    (mockImplementation.verify(verificationMode: AtMostOnce()) as!
      MockImplementation).doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int)

    //Then
    XCTAssertNotNil(failer.message)
    XCTAssertNotNil(failer.file)
    XCTAssertNotNil(failer.line)
  }

  func testVerificationModeTimesSucceedsWhenMethodIsCalledGivenTimes() {
    //Given
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)

    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)
    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)

    //When
    (mockImplementation.verify(verificationMode: Times(times: 2)) as!
      MockImplementation).doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int)

    //Then
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)
  }

  func testVerificationModeTimesFailsWhenMethodIsCalledLessThanGivenTimes() {
    //Given
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)

    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)

    //When
    (mockImplementation.verify(verificationMode: Times(times: 2)) as!
      MockImplementation).doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int)

    //Then
    XCTAssertNotNil(failer.message)
    XCTAssertNotNil(failer.file)
    XCTAssertNotNil(failer.line)
  }

  func testVerificationModeTimesFailsWhenMethodIsCalledMoreThanGivenTimes() {
    //Given
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)

    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)
    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)
    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)

    //When
    (mockImplementation.verify(verificationMode: Times(times: 2)) as!
      MockImplementation).doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int)

    //Then
    XCTAssertNotNil(failer.message)
    XCTAssertNotNil(failer.file)
    XCTAssertNotNil(failer.line)
  }

  func testVerificationModeAtLeastTimesSucceedsWhenMethodIsCalledGivenTimes() {
    //Given
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)

    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)
    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)

    //When
    (mockImplementation.verify(verificationMode: AtLeastTimes(times: Times(times: 2))) as!
      MockImplementation).doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int)

    //Then
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)
  }

  func testVerificationModeAtLeastTimesSucceedsWhenMethodIsCalledMoreThanGivenTimes() {
    //Given
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)

    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)
    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)
    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)

    //When
    (mockImplementation.verify(verificationMode: AtLeastTimes(times: Times(times: 2))) as!
      MockImplementation).doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int)

    //Then
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)
  }

  func testVerificationModeAtLeastTimesFailsWhenMethodIsCalledLessThanGivenTimes() {
    //Given
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)

    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)

    //When
    (mockImplementation.verify(verificationMode: AtLeastTimes(times: Times(times: 2))) as!
      MockImplementation).doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int)

    //Then
    XCTAssertNotNil(failer.message)
    XCTAssertNotNil(failer.file)
    XCTAssertNotNil(failer.line)
  }

  func testVerificationModeAtMostTimesSucceedsWhenMethodIsCalledGivenTimes() {
    //Given
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)

    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)
    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)

    //When
    (mockImplementation.verify(verificationMode: AtMostTimes(times: Times(times: 2))) as!
      MockImplementation).doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int)

    //Then
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)
  }

  func testVerificationModeAtMostTimesFailsWhenMethodIsCalledMoreThanGivenTimes() {
    //Given
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)

    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)
    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)
    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)

    //When
    (mockImplementation.verify(verificationMode: AtMostTimes(times: Times(times: 2))) as!
      MockImplementation).doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int)

    //Then
    XCTAssertNotNil(failer.message)
    XCTAssertNotNil(failer.file)
    XCTAssertNotNil(failer.line)
  }

  func testVerificationModeAtMostTimesSucceedsWhenMethodIsCalledLessThanGivenTimes() {
    //Given
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)

    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)

    //When
    (mockImplementation.verify(verificationMode: AtMostTimes(times: Times(times: 2))) as!
      MockImplementation).doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int)

    //Then
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)
  }

  func testVerificationModeNeverSucceedsWhenMethodIsNeverCalled() {
    //Given
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)

    //When
    (mockImplementation.verify(verificationMode: Never()) as!
      MockImplementation).doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int)

    //Then
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)
  }

  func testVerificationModeNeverFailWhenMethodIsCalled() {
    //Given
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)

    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)

    //When
    (mockImplementation.verify(verificationMode: Never()) as!
      MockImplementation).doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int)

    //Then
    XCTAssertNotNil(failer.message)
    XCTAssertNotNil(failer.file)
    XCTAssertNotNil(failer.line)
  }

  func testVerificationModeOnlySucceedsWhenMethodIsOnlyCalled() {
    //Given
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)

    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)

    //When
    (mockImplementation.verify(verificationMode: Only()) as!
      MockImplementation).doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int)

    //Then
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)
  }

  func testVerificationModeOnlyFailsWhenMethodIsNotOnlyCalled() {
    //Given
    XCTAssertNil(failer.message)
    XCTAssertNil(failer.file)
    XCTAssertNil(failer.line)

    mockImplementation.doSomethingWithNoArguments()
    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 1)

    //When
    (mockImplementation.verify(verificationMode: Only()) as!
      MockImplementation).doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int)

    //Then
    XCTAssertNotNil(failer.message)
    XCTAssertNotNil(failer.file)
    XCTAssertNotNil(failer.line)
  }
}


// MARK:- Test cases for CallHandler state `GetArgs`


extension CallHandlerTests {

  func testGetArgsReturnsCorrectNonNilArgumentsWhenMethodIsCalledOnce() {
    //Given
    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 2)

    //When
    let arguments = mockImplementation.getArgs(callOrder: 1).of(mockImplementation.doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int))

    //Then
    XCTAssertEqual(arguments![0] as? String, "one")
    XCTAssertEqual(arguments![1] as? Int, 2)
  }

  func testGetArgsReturnsCorrectNilArgumentsWhenMethodIsCalledOnce() {
    //Given
    mockImplementation.doSomethingWithSomeOptionalArguments(nil, arg2: 2)

    //When
    let arguments = mockImplementation.getArgs(callOrder: 1).of(mockImplementation.doSomethingWithSomeOptionalArguments(AnyValue.string, arg2: AnyValue.int))

    //Then
    XCTAssertNil(arguments![0])
    XCTAssertEqual(arguments![1] as? Int, 2)
  }

  func testGetArgsReturnsCorrectNonNilArgumentsWhenMethodIsCalledMultipleTimes() {
    //Given
    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 2)
    mockImplementation.doSomethingWithNonOptionalArguments("two", arg2: 3)

    //When
    let argumentsOfFirstCall = mockImplementation.getArgs(callOrder: 1).of(mockImplementation.doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int))
    let argumentsOfSecondCall = mockImplementation.getArgs(callOrder: 2).of(mockImplementation.doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int))

    //Then
    XCTAssertEqual(argumentsOfFirstCall![0] as? String, "one")
    XCTAssertEqual(argumentsOfFirstCall![1] as? Int, 2)

    XCTAssertEqual(argumentsOfSecondCall![0] as? String, "two")
    XCTAssertEqual(argumentsOfSecondCall![1] as? Int, 3)
  }

  func testGetArgsReturnsCorrectNonNilArgumentsWhenMultipleMethodsAreCalled() {
    //Given
    mockImplementation.doSomethingWithNonOptionalArguments("one", arg2: 2)
    mockImplementation.doSomethingWithSomeOptionalArguments("two", arg2: 4)

    //When
    let argumentsOfFirstMethod = mockImplementation.getArgs(callOrder: 1).of(mockImplementation.doSomethingWithNonOptionalArguments(AnyValue.string, arg2: AnyValue.int))
    let argumentsOfSecondMethod = mockImplementation.getArgs(callOrder: 1).of(mockImplementation.doSomethingWithSomeOptionalArguments(AnyValue.string, arg2: AnyValue.int))

    //Then
    XCTAssertEqual(argumentsOfFirstMethod![0] as? String, "one")
    XCTAssertEqual(argumentsOfFirstMethod![1] as? Int, 2)

    XCTAssertEqual(argumentsOfSecondMethod![0] as? String, "two")
    XCTAssertEqual(argumentsOfSecondMethod![1] as? Int, 4)
  }
}