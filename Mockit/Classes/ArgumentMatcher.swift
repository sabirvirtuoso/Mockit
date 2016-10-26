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
 * `ArgumentMatcher` provides an API for custom implementation of argument matcher requirements.
 */
public protocol ArgumentMatcher {

  func match(arguments args: Any?, withArguments withArgs: Any?) -> Bool

}


// MARK:- Implementation of custom ArgumentMatcher `Anything`

/**
 * `Anything` does not match arguments and will unconditionally return true
 */
open class Anything: ArgumentMatcher {

  public init() {

  }

  open func match(arguments args: Any?, withArguments withArgs: Any?) -> Bool {
    return true
  }

}


// MARK:- Implementation of custom ArgumentMatcher `Exact`

/**
 * `Exact` exactly matches arguments
 */
open class Exact: ArgumentMatcher {

  public init() {

  }

  open func match(arguments args: Any?, withArguments withArgs: Any?) -> Bool {
    return MockMatcher.sharedInstance.match(arguments: args, withArguments: withArgs)
  }

}
