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

  func verify(_ verificationData: VerificationData, mockFailer: MockFailer)

}


// MARK:- Custom Verification Mode `Once` implementation


open class Once: VerificationMode {

  public init() {

  }

  open func verify(_ verificationData: VerificationData, mockFailer: MockFailer) {
    guard verificationData.timesInvoked == 1 else {
      let failerMessage = String(format: StringConstants.FailureMessages.verificationModeOnce,
                                        verificationData.functionName, verificationData.timesInvoked)
      mockFailer.doFail(failerMessage, file: verificationData.file, line: verificationData.line)

      return
    }
  }

}


// MARK:- Custom Verification Mode `AtLeastOnce` implementation


open class AtLeastOnce: VerificationMode {

  public init() {

  }

  open func verify(_ verificationData: VerificationData, mockFailer: MockFailer) {
    guard verificationData.timesInvoked >= 1 else {
      let failerMessage = String(format: StringConstants.FailureMessages.verificationModeAtLeastOnce,
                          verificationData.functionName, verificationData.timesInvoked)
      mockFailer.doFail(failerMessage, file: verificationData.file, line: verificationData.line)

      return
    }
  }

}


// MARK:- Custom Verification Mode `AtMostOnce` implementation


open class AtMostOnce: VerificationMode {

  public init() {

  }

  open func verify(_ verificationData: VerificationData, mockFailer: MockFailer) {
    guard verificationData.timesInvoked <= 1 else {
      let failerMessage = String(format: StringConstants.FailureMessages.verificationModeAtMostOnce,
                                 verificationData.functionName, verificationData.timesInvoked)
      mockFailer.doFail(failerMessage, file: verificationData.file, line: verificationData.line)

      return
    }
  }

}


// MARK:- Custom Verification Mode `Times` implementation


open class Times: VerificationMode {

  var times = 0

  public init(times: Int) {
    self.times = times
  }

  open func verify(_ verificationData: VerificationData, mockFailer: MockFailer) {
    guard verificationData.timesInvoked == times else {
      let failerMessage = String(format: StringConstants.FailureMessages.verificationModeTimes,
                                 verificationData.functionName, times, verificationData.timesInvoked)
      mockFailer.doFail(failerMessage, file: verificationData.file, line: verificationData.line)

      return
    }
  }

}


// MARK:- Custom Verification Mode `AtLeastTimes` implementation


open class AtLeastTimes: VerificationMode {

  var times = 0

  public init(times: Times) {
    self.times = times.times
  }

  open func verify(_ verificationData: VerificationData, mockFailer: MockFailer) {
    guard verificationData.timesInvoked >= times else {
      let failerMessage = String(format: StringConstants.FailureMessages.verificationModeAtLeastTimes,
                                 verificationData.functionName, times, verificationData.timesInvoked)
      mockFailer.doFail(failerMessage, file: verificationData.file, line: verificationData.line)

      return
    }
  }

}


// MARK:- Custom Verification Mode `AtMostTimes` implementation


open class AtMostTimes: VerificationMode {

  var times = 0

  public init(times: Times) {
    self.times = times.times
  }

  open func verify(_ verificationData: VerificationData, mockFailer: MockFailer) {
    guard verificationData.timesInvoked <= times else {
      let failerMessage = String(format: StringConstants.FailureMessages.verificationModeAtMostTimes,
                                 verificationData.functionName, times, verificationData.timesInvoked)
      mockFailer.doFail(failerMessage, file: verificationData.file, line: verificationData.line)

      return
    }
  }

}


// MARK:- Custom Verification Mode `Never` implementation


open class Never: VerificationMode {

  public init() {

  }

  open func verify(_ verificationData: VerificationData, mockFailer: MockFailer) {
    guard verificationData.timesInvoked == 0 else {
      let failerMessage = String(format: StringConstants.FailureMessages.verificationModeNever,
                                 verificationData.functionName, verificationData.timesInvoked)
      mockFailer.doFail(failerMessage, file: verificationData.file, line: verificationData.line)

      return
    }
  }

}


// MARK:- Custom Verification Mode `Only` implementation


open class Only: VerificationMode {

  public init() {

  }

  open func verify(_ verificationData: VerificationData, mockFailer: MockFailer) {
    guard verificationData.calledOnly else {
      let failerMessage = String(format: StringConstants.FailureMessages.verificationModeOnly,
                                 verificationData.functionName)
      mockFailer.doFail(failerMessage, file: verificationData.file, line: verificationData.line)

      return
    }
  }

}
