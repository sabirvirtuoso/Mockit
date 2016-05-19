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
  
  private var state: State!
  private var verificationMode: VerificationMode!

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
    argumentsOfSpecificCall = args
    
    return returnValue
  }

  private func transtion(toState state: State) {
    self.state = state
  }
}
