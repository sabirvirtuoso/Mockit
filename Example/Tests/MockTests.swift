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


// MARK:- A test implementation of `CallHandler` protocol


class TestCallHandler: CallHandler {

  let testCase: XCTestCase
  var stub: Stub!

  var whenCalled = false
  var verifyCalled = false

  init(withTestCase testCase: XCTestCase) {
    self.testCase = testCase
  }

  func when() -> Stub {
    whenCalled = true
    stub = Stub()
    
    return stub
  }

  func verify(verificationMode mode: VerificationMode) {
    verifyCalled = true
  }
}


// MARK:- A test implementation of VerificationMode


class TestVerificationMode: VerificationMode {

  func verify(verificationData: VerificationData, mockFailer: MockFailer) {
    // Dummy, do nothing
  }
}


// MARK:- A test implementation of `Mock` protocol


class TestMockImplementation: Mock {

  var callHandler: CallHandler

  init(withCallHandler callHandler: CallHandler) {
    self.callHandler = callHandler
  }
}

class MockTests: XCTestCase {

  func testWhenIsCalled() {
    //given
    let handler = TestCallHandler(withTestCase: self)
    let sut = TestMockImplementation(withCallHandler: handler)
    
    XCTAssertFalse(handler.whenCalled)
    
    //when
    sut.when()
    
    //then
    XCTAssertTrue(handler.whenCalled)
  }

  func testCallingWhenReturnsCorrectStub() {
    //given
    let handler = TestCallHandler(withTestCase: self)
    let sut = TestMockImplementation(withCallHandler: handler)

    XCTAssertNil(handler.stub)

    //when
    let stub = sut.when()

    //then
    XCTAssertTrue(stub === handler.stub)
  }

  func testVerifyIsCalled() {
    //given
    let handler = TestCallHandler(withTestCase: self)
    let sut = TestMockImplementation(withCallHandler: handler)

    XCTAssertFalse(handler.verifyCalled)

    //when
    sut.verify(verificationMode: TestVerificationMode())

    //then
    XCTAssertTrue(handler.verifyCalled)
  }

  func testCallingVerifyReturnsCorrectMock() {
    //given
    let handler = TestCallHandler(withTestCase: self)
    let sut = TestMockImplementation(withCallHandler: handler)

    //when
    let mock = sut.verify(verificationMode: TestVerificationMode())

    //then
    XCTAssertTrue((mock as! AnyObject) === sut)
  }
}
