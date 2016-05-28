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


// MARK:- CallHandlerTests setup


class CallHandlerTests: XCTestCase {

  var mockImplementation: MockImplementation!
  var sut: CallHandlerImpl!

  override func setUp() {
    sut = CallHandlerImpl(withTestCase: self)
    mockImplementation = MockImplementation(withCallHandler: sut)
  }
}