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


// MARK:- Call Handler implementation


open class CallHandlerImpl: CallHandler {

  open var argumentsOfSpecificCall: [Any?]?

  fileprivate let mockFailer: MockFailer

  // this is the stub which is currenly being configured or called
  fileprivate var stub: Stub!
  fileprivate var stubs = [Stub]()

  fileprivate var state = State.none
  fileprivate var verificationMode: VerificationMode!

  fileprivate var callHistory = [String: [[Any?]]]()
  fileprivate var callOrder = 1

  public init(withTestCase testCase: XCTestCase) {
    mockFailer = MockFailerImpl(withTestCase: testCase)
  }

  public init(withFailer failer: MockFailer) {
    mockFailer = failer
  }

  open func when() -> Stub {
    transtion(toState: .when)
    stub = Stub()

    return stub
  }

  open func verify(verificationMode mode: VerificationMode = Once()) {
    verificationMode = mode
    transtion(toState: .verify)
  }

  open func getArgs(callOrder order: Int = 1) {
    guard order > 0 else {
      mockFailer.doFail("Call Order of a method must be greater than 0", file: "", line: 0)

      return
    }

    callOrder = order
    transtion(toState: .getArgs)
  }

  @discardableResult
  open func accept(_ returnValue: Any?, ofFunction function: String, atFile file: String,
                     inLine line: Int, withArgs args: Any?...) -> Any? {
    switch state {
      case .none:
        recordCallHistory(ofFunction: function, withArgs: args)

        if stubCalled(ofFunction: function, withArgs: args) {
            return stub.performActions()
        }
      case .when:
        registerStub(ofFunction: function, withArgs: args)

        transtion(toState: .none)
      case .verify:
        verifyCall(ofFunction: function, atFile: file, inLine: line)

        transtion(toState: .none)
      case .getArgs:
        assignArguments(ofFunction: function)

        transtion(toState: .none)
    }

    return returnValue
  }

  fileprivate func transtion(toState state: State) {
    self.state = state
  }

}


// MARK:- CallHandler state `None` functionalities


extension CallHandlerImpl {

  fileprivate func recordCallHistory(ofFunction function: String, withArgs args: [Any?]) {
    callHistory[function] = callHistory[function] ?? []

    callHistory[function]!.append(args)
  }

  fileprivate func stubCalled(ofFunction function: String, withArgs args: [Any?]) -> Bool {
    for stub in stubs {
      if match(stub, withFunctionName: function, andArgs: args) {
        self.stub = stub

        return true
      }
    }

    return false
  }

  fileprivate func match(_ stub: Stub, withFunctionName functionName: String, andArgs args: [Any?]) -> Bool {
    return stub.satisfyStub(withFunctionName: functionName) && stub.satisfyStub(withActualArgs: args)
  }

}


// MARK:- CallHandler state `When` functionalities


extension CallHandlerImpl {

  fileprivate func registerStub(ofFunction function: String, withArgs args: [Any?]) {
    stub.acceptStub(withFunctionName: function, andExpectedArgs: args)

    stubs.append(stub)
  }

}


// MARK:- CallHandler state `Verify` functionalities


extension CallHandlerImpl {

  fileprivate func verifyCall(ofFunction function: String, atFile file: String,
                                     inLine line: Int) {
    let timesCalled = timesInvoked(function)
    let calledOnly = invokedOnly(function)

    let verificationData = VerificationData(build: {
      $0.functionName = function
      $0.calledOnly = calledOnly
      $0.timesInvoked = timesCalled
      $0.file = file
      $0.line = line
    })

    verificationMode.verify(verificationData, mockFailer: mockFailer)
  }

  fileprivate func timesInvoked(_ function: String) -> Int {
    guard let arguments = callHistory[function] else {
      return 0
    }

    return arguments.count
  }

  fileprivate func invokedOnly(_ function: String) -> Bool {
    guard let _ = callHistory[function] else {
      return false
    }

    return callHistory.count == 1
  }

}


// MARK:- CallHandler state `GetArgs` functionalities


extension CallHandlerImpl {

  fileprivate func assignArguments(ofFunction functionName: String) {
    guard let arguments = callHistory[functionName] else {
      mockFailer.doFail("No arguments are recorded for method \(functionName)", file: "", line: 0)

      return
    }

    guard callOrder <= arguments.count else {
      mockFailer.doFail("Call Order for method \(functionName) is greater than number of times method is called", file: "", line: 0)

      return
    }

    argumentsOfSpecificCall = arguments[callOrder - 1]
  }

}
