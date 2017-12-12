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

/**
 * `CallHandler` is the main workhorse. It intercepts all calls and performs necessary actions
 * like registering a stub, performing actions on a specific stub, recording a call, verifying a call as well as
 * returning arguments passed to a specific method call. Each action performed depends on the current state of the
 * call handler which defaults to None. The mock interface interacts with the call handler to set this state.
 */
public protocol CallHandler {

  var argumentsOfSpecificCall: [Any?]? { get }

  func when() -> Stub

  func verify(verificationMode mode: VerificationMode)

  func getArgs(callOrder order: Int)

  @discardableResult
  func accept(_ returnValue: Any?, ofFunction function: String, atFile file: String,
                     inLine line: Int, withArgs args: Any?...) -> Any?

}
