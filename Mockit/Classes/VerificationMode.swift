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
 * `VerificationMode` provides an API for custom verification modes to implement.
 */
public protocol VerificationMode {

  func verify(verificationData: VerificationData, mockFailer: MockFailer)

}


// MARK:- Custom Verification Mode `Once` implementation


public class Once: VerificationMode {

  public init() {
  
  }

  public func verify(verificationData: VerificationData, mockFailer: MockFailer) {
    guard verificationData.timesInvoked == 1 else {
      let failerMessage = String(format: StringConstants.FailureMessages.verificationModeOnce,
                                        verificationData.functionName, verificationData.timesInvoked)
      mockFailer.doFail(failerMessage, file: verificationData.file, line: verificationData.line)

      return
    }
  }
}
