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


public class CallHandlerImpl: CallHandler {

  public var argumentsOfSpecificCall: [Any?]?

  private let mockFailer: MockFailer

  // this is the stub which is currenly being configured or called
  private var stub: Stub!
  private var stubs = [Stub]()

  private var state = State.None
  private var verificationMode: VerificationMode!

  private var callHistory = [String: [[Any?]]]()
  private var callOrder = 1

  public init(withTestCase testCase: XCTestCase) {
    mockFailer = MockFailerImpl(withTestCase: testCase)
  }

  public init(withFailer failer: MockFailer) {
    mockFailer = failer
  }

  public func when() -> Stub {
    transtion(toState: .When)
    stub = Stub()

    return stub
  }

  public func verify(verificationMode mode: VerificationMode) {
    verificationMode = mode
    transtion(toState: .Verify)
  }

  public func getArgs(callOrder order: Int) {
    guard order > 0 else {
      mockFailer.doFail("Call Order of a method must be greater than 0", file: "", line: 0)

      return
    }

    callOrder = order
    transtion(toState: .GetArgs)
  }

  public func accept(returnValue: Any?, ofFunction function: String, atFile file: String,
                     inLine line: UInt, withArgs args: Any?...) -> Any? {
    switch state {
      case .None:
        recordCallHistory(ofFunction: function, withArgs: args)

        if stubCalled(ofFunction: function, withArgs: args) {
            return stub.performActions()
        }
      case .When:
        registerStub(ofFunction: function, withArgs: args)

        transtion(toState: .None)
      case .Verify:
        verifyCall(ofFunction: function, atFile: file, inLine: line)

        transtion(toState: .None)
      case .GetArgs:
        assignArguments(ofFunction: function)

        transtion(toState: .None)
    }

    return returnValue
  }

  private func transtion(toState state: State) {
    self.state = state
  }

}


// MARK:- CallHandler state `None` functionalities


extension CallHandlerImpl {

  private func recordCallHistory(ofFunction function: String, withArgs args: [Any?]) {
    callHistory[function] = callHistory[function] ?? []

    callHistory[function]!.append(args)
  }

  private func stubCalled(ofFunction function: String, withArgs args: [Any?]) -> Bool {
    for stub in stubs {
      if match(stub, withFunctionName: function, andArgs: args) {
        self.stub = stub

        return true
      }
    }

    return false
  }

  private func match(stub: Stub, withFunctionName functionName: String, andArgs args: [Any?]) -> Bool {
    return stub.satisfyStub(withFunctionName: functionName) && stub.satisfyStub(withActualArgs: args)
  }

}


// MARK:- CallHandler state `When` functionalities


extension CallHandlerImpl {

  private func registerStub(ofFunction function: String, withArgs args: [Any?]) {
    stub.acceptStub(withFunctionName: function, andExpectedArgs: args)

    stubs.append(stub)
  }

}


// MARK:- CallHandler state `Verify` functionalities


extension CallHandlerImpl {

  private func verifyCall(ofFunction function: String, atFile file: String,
                                     inLine line: UInt) {
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

  private func timesInvoked(function: String) -> Int {
    guard let arguments = callHistory[function] else {
      return 0
    }

    return arguments.count
  }

  private func invokedOnly(function: String) -> Bool {
    guard let _ = callHistory[function] else {
      return false
    }

    return callHistory.count == 1
  }

}


// MARK:- CallHandler state `GetArgs` functionalities


extension CallHandlerImpl {

  private func assignArguments(ofFunction functionName: String) {
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
