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

@testable import Mockit_Example

// MARK:- Example test cases to demonstrate how Mockit can be used. They are not the unit tests for the Mockit framework.

class ExampleTests: XCTestCase {

  var mockCollaborator: MockExampleCollaborator!
  var sut: Example!

  override func setUp() {
    super.setUp()

    mockCollaborator = MockExampleCollaborator(testCase: self)
    sut = Example(theCollaborator: mockCollaborator)
  }

  func testDoSomething() {
    //Given

    //When
    sut.doSomething()

    //Then
    (mockCollaborator.verify(verificationMode: Once()) as! MockExampleCollaborator).voidFunction()
  }

  func testDoSomethingWithParameters() {
    //Given
    mockCollaborator.when().call(withReturnValue: mockCollaborator.function(42, "frood")).thenReturn("hoopy")

    //When
    let returnValue = sut.doSomethingWithParamters(42, "frood")

    //Then
    XCTAssertEqual(returnValue, "hoopy")
  }

  func testStringDictionary() {
    //Given
    mockCollaborator.when().call(withReturnValue: mockCollaborator.stringDictFunction(["Hello":"Pong"])).thenReturn("ping")

    //When
    let returnValue = sut.doSomethingWithDictParameters(["Hello":"Pong"])

    //Then
    XCTAssertEqual(returnValue, "ping")
  }

  func testWithThenDoClosure() {
    //Given
    mockCollaborator.when().call(withReturnValue: mockCollaborator.voidFunction()).thenDo {
      (args: [Any?]) -> Void in

      // if the call is received, this closure will be executed
      print("===== thenDo closure called =====")
    }

    //When
    sut.doSomething()

    //Then...
  }

  func testActionChainingForCorrespondingCalls() {
    //Given
    mockCollaborator.when().call(withReturnValue: mockCollaborator.stringDictFunction(["Hello":"Pong"])).thenReturn("ping", "hoopy")

    //When
    let returnValueOfFirstCall = sut.doSomethingWithDictParameters(["Hello":"Pong"])
    let returnValueOfSecondCall = sut.doSomethingWithDictParameters(["Hello":"Pong"])

    //Then
    XCTAssertEqual(returnValueOfFirstCall, "ping")
    XCTAssertEqual(returnValueOfSecondCall, "hoopy")
  }

  func testActionChainingForNonCorrespondingCalls() {
    //Given
    mockCollaborator.when().call(withReturnValue: mockCollaborator.stringDictFunction(["Hello":"Pong"])).thenReturn("hoopy")

    //When
    let returnValueOfFirstCall = sut.doSomethingWithDictParameters(["Hello":"Pong"])
    let returnValueOfSecondCall = sut.doSomethingWithDictParameters(["Hello":"Pong"])

    //Then
    XCTAssertEqual(returnValueOfFirstCall, "hoopy")
    XCTAssertEqual(returnValueOfSecondCall, "hoopy")
  }

  func testGetArgsOfDoSomethingWithParameters() {
    //Given
    sut.doSomethingWithParamters(42, "frood")
    sut.doSomethingWithParamters(18, "hoopy")

    //When
    let argumentsOfFirstCall = mockCollaborator.getArgs(callOrder: 1).of(mockCollaborator.function(AnyValue.int, AnyValue.string))
    let argumentsOfSecondCall = mockCollaborator.getArgs(callOrder: 2).of(mockCollaborator.function(AnyValue.int, AnyValue.string))

    //Then
    XCTAssertEqual(argumentsOfFirstCall![0] as? Int, 42)
    XCTAssertEqual(argumentsOfFirstCall![1] as? String, "frood")

    XCTAssertEqual(argumentsOfSecondCall![0] as? Int, 18)
    XCTAssertEqual(argumentsOfSecondCall![1] as? String, "hoopy")
  }

  func testExpectMethodOneAndThree() {
    //Given

    //When
    sut.ExpectMethodOneAndThree()

    //Then
    (mockCollaborator.verify(verificationMode: Once()) as! MockExampleCollaborator).methodOne()
    (mockCollaborator.verify(verificationMode: Never()) as! MockExampleCollaborator).methodTwo()
    (mockCollaborator.verify(verificationMode: Once()) as! MockExampleCollaborator).methodThree()
  }

  func testExpectMethodOneTwice() {
    //Given

    //When
    sut.ExpectMethodOneTwice()

    //Then
    (mockCollaborator.verify(verificationMode: Times(times: 2)) as! MockExampleCollaborator).methodOne()
  }

  func testExpectOnlyMethodThree() {
    //Given

    //When
    sut.ExpectOnlyMethodThree()

    //Then
    (mockCollaborator.verify(verificationMode: Only()) as! MockExampleCollaborator).methodThree()
  }

  func testExpectAllThreeMethods() {
    //Given

    //When
    sut.ExpectAllThreeMethods()

    //Then
    (mockCollaborator.verify(verificationMode: Once()) as! MockExampleCollaborator).methodOne()
    (mockCollaborator.verify(verificationMode: AtLeastOnce()) as! MockExampleCollaborator).methodTwo()
    (mockCollaborator.verify(verificationMode: AtMostOnce()) as! MockExampleCollaborator).methodThree()
  }

  func testExpectNoMethod() {
    //Given

    //When
    sut.ExpectNoMethod()

    //Then
    (mockCollaborator.verify(verificationMode: Never()) as! MockExampleCollaborator).methodOne()
    (mockCollaborator.verify(verificationMode: Never()) as! MockExampleCollaborator).methodTwo()
    (mockCollaborator.verify(verificationMode: Never()) as! MockExampleCollaborator).methodThree()
  }

  func testExpectMethodTwoAndThree() {
    //Given

    //When
    sut.ExpectMethodTwoAndThree()

    //Then
    (mockCollaborator.verify(verificationMode: AtLeastTimes(times: Times(times: 1))) as! MockExampleCollaborator).methodTwo()
    (mockCollaborator.verify(verificationMode: Never()) as! MockExampleCollaborator).methodOne()
    (mockCollaborator.verify(verificationMode: AtMostTimes(times: Times(times: 3))) as! MockExampleCollaborator).methodThree()
  }
}