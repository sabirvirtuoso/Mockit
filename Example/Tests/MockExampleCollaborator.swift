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

import Foundation
import XCTest
import Mockit

@testable import Mockit_Example


// MARK:- The mock ExampleCollaborator. This exists in the test target.


class MockExampleCollaborator: ExampleCollaborator, Mock {

  let callHandler: CallHandler

  init(testCase: XCTestCase) {
    callHandler = CallHandlerImpl(withTestCase: testCase)
  }

  func instanceType() -> MockExampleCollaborator {
    return self
  }

  override func voidFunction() {
    callHandler.accept(nil, ofFunction: #function, atFile: #file, inLine: #line, withArgs: nil)
  }

  override func function(int: Int, _ string: String) -> String {
    return callHandler.accept("", ofFunction: #function, atFile: #file, inLine: #line, withArgs: int, string) as! String
  }

  override func stringDictFunction(dict: Dictionary<String, String>) -> String {
    return callHandler.accept("", ofFunction: #function, atFile: #file, inLine: #line, withArgs: dict) as! String
  }

  override func methodOne() {
    callHandler.accept(nil, ofFunction: #function, atFile: #file, inLine: #line, withArgs: nil)
  }

  override func methodTwo() {
    callHandler.accept(nil, ofFunction: #function, atFile: #file, inLine: #line, withArgs: nil)
  }

  override func methodThree() {
    callHandler.accept(nil, ofFunction: #function, atFile: #file, inLine: #line, withArgs: nil)
  }

}
