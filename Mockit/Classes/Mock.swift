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
 * `Mock` and its extension acts as a proxy to the real workhorse, CallHandler.
 * It's here to reduce the amount of boiler-plate code when creating mock objects.
 */
public protocol Mock {

  associatedtype InstanceType

  var callHandler: CallHandler { get }

  func instanceType() -> InstanceType

  func when() -> Stub

  func verify(verificationMode mode: VerificationMode) -> InstanceType

  func getArgs(callOrder order: Int) -> InstanceType

  func of(_ returnValue: Any?) -> [Any?]?

}


// MARK:- Mock extension to implement protocol methods


public extension Mock {

  func when() -> Stub {
    return callHandler.when()
  }

  func verify(verificationMode mode: VerificationMode) -> InstanceType {
    callHandler.verify(verificationMode: mode)

    return instanceType()
  }

  func getArgs(callOrder order: Int) -> InstanceType {
    callHandler.getArgs(callOrder: order)

    return instanceType()
  }

  func of(_ returnValue: Any?) -> [Any?]? {
    return callHandler.argumentsOfSpecificCall
  }

}
