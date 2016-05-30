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


// MARK:- The example class we are testing


class Example {

  let collaborator: ExampleCollaborator

  init(theCollaborator collaborator: ExampleCollaborator) {
    self.collaborator = collaborator
  }

  func doSomething() {
    // test will fail if this call isn't made
    collaborator.voidFunction()
  }

  func doSomethingWithParamters(int: Int, _ string: String) -> String {
    // test will fail if this call isn't made
    return collaborator.function(int, string)
  }

  func doSomethingWithDictParameters(dict: Dictionary<String, String>) -> String {
    return collaborator.stringDictFunction(dict)
  }

  func expectMethodOneAndThree() {
    collaborator.methodOne()
    collaborator.methodThree()
  }

  func expectMethodOneTwice() {
    collaborator.methodOne()
    collaborator.methodOne()
  }

  func expectOnlyMethodThree() {
    collaborator.methodThree()
  }

  func expectAllThreeMethods() {
    collaborator.methodOne()

    collaborator.methodTwo()
    collaborator.methodTwo()

    collaborator.methodThree()
  }

  func expectNoMethod() {
    // call nothing
  }

  func expectMethodTwoAndThree() {
    collaborator.methodTwo()

    collaborator.methodThree()
    collaborator.methodThree()
  }

  func expectMethodTwoAtLeast() {
    collaborator.methodTwo()
  }

  func ExpectOnlyMethodOne() {
    collaborator.methodOne()
  }

}
