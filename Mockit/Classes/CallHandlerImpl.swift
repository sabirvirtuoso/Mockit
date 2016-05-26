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

  public var argumentsOfSpecificCall: [Any?]!
  
  private let mockFailer: MockFailer

  // this is the stub which is currenly being configured (if any)
  private var stub: Stub!
  private var stubs = [Stub]()
  
  private var state: State!
  private var verificationMode: VerificationMode!

  private var callHistory = [String: [[Any?]]]()

  public init(_ testCase: XCTestCase) {
    mockFailer = MockFailerImpl(withTestCase: testCase)
  }

  public init(_ failer: MockFailer) {
    mockFailer = failer
  }

  public func when() -> Stub {
    transtion(toState: .When)
    stub = Stub()
    
    return stub
  }

  public func verify(verificationMode mode: VerificationMode) {
    transtion(toState: .Verify)
  }

  public func getArgs(callOrder order: Int) {
    transtion(toState: .GetArgs)
  }
  
  public func accept(returnValue: Any?, ofFunction function: String, atFile file: String,
                     inLine line: UInt, withArgs args: Any?...) -> Any? {
    switch(state) {
      case .None:
        recordCallHistory(ofFunction: function, withArgs: args)

        if stubCalled(ofFunction: function, withArgs: args) {
            return stub.performActions()
        }
//      case .When: break
//      case .Verify: break
//      case .GetArgs: break
      default: break
    }

    argumentsOfSpecificCall = args
    
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