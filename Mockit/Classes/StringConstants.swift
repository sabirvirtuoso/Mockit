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

public struct StringConstants {

  public struct FailureMessages {

    public static let verificationModeOnce = "Expected %@ to be called Once. It is actually called %d times"
    public static let verificationModeAtLeastOnce = "Expected %@ to be called At Least Once. It is actually called %d times"
    public static let verificationModeAtMostOnce = "Expected %@ to be called At Most Once. It is actually called %d times"

    public static let verificationModeTimes = "Expected %@ to be called %d times. It is actually called %d times"
    public static let verificationModeAtLeastTimes = "Expected %@ to be called At Least %d times. It is actually called %d times"
    public static let verificationModeAtMostTimes = "Expected %@ to be called At Most %d times. It is actually called %d times"

    public static let verificationModeOnly = "Expected only %@ to be called."
    public static let verificationModeNever = "Expected %@ to be never called. It is actually called %d times"

  }

}
